//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class UserProfilePresenter: UserProfileViewOutput {
    
    static let headerHeight = Constants.UserProfile.summaryHeight +
        Constants.UserProfile.filterHeight +
        Constants.UserProfile.containerInset
    
    weak var view: UserProfileViewInput!
    var router: UserProfileRouterInput!
    var interactor: UserProfileInteractorInput!
    var feedViewController: UIViewController?
    var feedModuleInput: FeedModuleInput?
    weak var moduleOutput: UserProfileModuleOutput?
    
    fileprivate let userID: String?
    fileprivate var user: User?
    fileprivate var me: User? {
        return myProfileHolder?.me
    }
    fileprivate var myProfileHolder: UserHolder?
    fileprivate let settings: Settings

    fileprivate var followersCount = 0 {
        didSet {
            view.setFollowersCount(followersCount)
        }
    }
    
    fileprivate var followingCount = 0 {
        didSet {
            view.setFollowingCount(followingCount)
        }
    }
    
    fileprivate let actionStrategy: AuthorizedActionStrategy
    
    init(userID: String? = nil,
         myProfileHolder: UserHolder,
         actionStrategy: AuthorizedActionStrategy,
         settings: Settings = AppConfiguration.shared.settings) {
        guard myProfileHolder.me != nil || userID != nil else {
            fatalError("Either userID or myProfileHolder must be supplied")
        }
        
        self.userID = userID
        followersCount = 0
        followingCount = 0
        self.myProfileHolder = myProfileHolder
        self.actionStrategy = actionStrategy
        self.settings = settings
    }
    
    func viewIsReady() {
        view.setupInitialState(showGalleryView: settings.showGalleryView)
        setupFeed()
        loadUser()
    }
    
    private func loadUser() {
        view.setIsLoadingUser(true)
        
        if let userID = userID {
            loadOtherUser(userID)
        } else if let credentials = me?.credentials {
            loadMe(credentials: credentials)
        } else {
            view.showError(APIError.missingUserData)
        }
    }
    
    private func loadMe(credentials: CredentialsList) {
        if let me = me {
            setUser(me)
        }
        
        interactor.getMe(credentials: credentials) { [weak self] result in
            self?.processUserResult(result, setter: {
                self?.myProfileHolder?.me = $0
            })
        }
    }
    
    private func loadOtherUser(_ userID: String) {
        if let user = interactor.cachedUser(with: userID) {
            setUser(user, setter: { [weak self] in self?.user = $0 })
        }
        
        interactor.getUser(userID: userID) { [weak self] result in
            self?.processUserResult(result, setter: { self?.user = $0 })
        }
    }
    
    private func processUserResult(_ result: Result<User>, setter: @escaping (User) -> Void) {
        view.setIsLoadingUser(false)
        
        if let user = result.value {
            setUser(user, setter: setter)
        } else {
            view.showError(result.error ?? APIError.unknown)
        }
    }
    
    fileprivate func setUser(_ user: User, setter: ((User) -> Void)? = nil) {
        setter?(user)
        followersCount = user.followersCount
        followingCount = user.followingCount
        view.setUser(user)
        feedModuleInput?.setHeaderHeight(view.headerContentHeight)
        if !user.isMe && user.isPrivate {
            view.setupPrivateAppearance()
        }
    }
    
    private func setupFeed() {
        guard let vc = feedViewController, let feedModuleInput = feedModuleInput else {
            return
        }
        feedModuleInput.registerHeader(
            withType: UICollectionReusableView.self,
            size: CGSize(width: Constants.UserProfile.contentWidth, height: UserProfilePresenter.headerHeight),
            configurator: view.setupHeaderView
        )
        
        view.setFeedViewController(vc)
        view.setLayoutAsset(feedModuleInput.layout.nextLayoutAsset)

        setFeedScope(.recent)
    }
    
    func onEdit() {
        if let me = me {
            router.openEditProfile(user: me)
        }
    }
    
    func onFollowing() {
        if let user = user ?? me {
            router.openFollowing(user: user)
        }
    }
    
    func onFollowRequest(currentStatus followStatus: FollowStatus) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._onFollowRequest(currentStatus: followStatus) }
    }
    
    private func _onFollowRequest(currentStatus followStatus: FollowStatus) {
        guard let user = user else { return }

        view.setIsProcessingFollowRequest(true)
        
        interactor.processSocialRequest(to: user) { [weak self] response in
            self?.processSocialResponse(response)
        }
    }
    
    private func processSocialResponse(_ response: Result<FollowStatus>) {
        view.setIsProcessingFollowRequest(false)

        if let status = response.value {
            updateFollowerStatus(status)
        } else {
            view.showError(response.error ?? APIError.unknown)
        }
    }
    
    private func updateFollowerStatus(_ status: FollowStatus) {
        view.setFollowStatus(status)
        followersCount = updatedFollowCount(followersCount, with: status)
        user?.followerStatus = status
        moduleOutput?.didChangeUserFollowStatus(user!)
    }
    
    fileprivate func updatedFollowCount(_ count: Int, with status: FollowStatus) -> Int {
        var count = count
        if status == .accepted {
            count += 1
        } else if status == .empty || status == .blocked {
            count = max(0, count - 1)
        }
        return count
    }
    
    func onFollowers() {
        if let user = user ?? me {
            router.openFollowers(user: user)
        }
    }
    
    func onMore() {
        if userID != nil {
            let user = User(uid: userID!)
            router.showUserMenu(
                user,
                blockHandler: { [weak self] in self?.block(user: user) },
                reportHandler: { [weak self] in self?.router.openReport(user: user) }
            )
        } else if let me = me {
            router.showMyMenu(
                addPostHandler: { [weak self] in self?.router.openCreatePost(user: me) },
                followRequestsHandler: { [weak self] in self?.router.openFollowRequests() }
            )
        }
    }
    
    private func block(user: User) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._block(user: user) }
    }
    
    private func _block(user: User) {
        view.setIsLoadingUser(true)
        
        interactor.block(user: user) { [weak self] result in
            self?.view.setIsLoadingUser(false)
            if result.isFailure {
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
    
    func onRecent() {
        setFeedScope(.recent)
    }
    
    func onPopular() {
        setFeedScope(.popular)
    }
    
    private func setFeedScope(_ scope: FeedType.UserFeedScope) {
        guard let uid = userID ?? me?.uid else { return }
        view.setFilterEnabled(false)
        feedModuleInput?.feedType = .user(user: uid, scope: scope)
    }
    
    func onFlipFeedLayout() {
        guard let feedModuleInput = feedModuleInput else {
            return
        }
        feedModuleInput.layout = feedModuleInput.layout.flipped
        view.setLayoutAsset(feedModuleInput.layout.nextLayoutAsset)
    }
}

extension UserProfilePresenter: FeedModuleOutput {
    
    func didScrollFeed(_ feedView: UIScrollView) {
        let isHeaderVisible = feedView.contentOffset.y < view.headerContentHeight - Constants.UserProfile.filterHeight
        view.setStickyFilterHidden(isHeaderVisible)
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.setFilterEnabled(true)
    }
    
    func shouldOpenProfile(for userID: String) -> Bool {
        return userID != self.userID && userID != me?.uid
    }
    
}

extension UserProfilePresenter {
    
    func didStartRefreshingData() { }
    
}

extension UserProfilePresenter: FollowersModuleOutput {
    
    func didUpdateFollowersStatus(newStatus: FollowStatus) {
        if user == nil {
            followingCount = updatedFollowCount(followingCount, with: newStatus)
        }
    }
}

extension UserProfilePresenter: FollowingModuleOutput {
    
    func didUpdateFollowingStatus(newStatus: FollowStatus) {
        if user == nil {
            followingCount = updatedFollowCount(followingCount, with: newStatus)
        }
    }
}

extension UserProfilePresenter: CreatePostModuleOutput {
    func didUpdatePost() {
        feedModuleInput?.refreshData()
    }
    
    func didCreatePost() {
        feedModuleInput?.refreshData()
    }
}

extension UserProfilePresenter: EditProfileModuleOutput {
    
    func onProfileEdited(me: User) {
        router.popTopScreen()
        setUser(me) { [weak self] in
            self?.myProfileHolder?.me = $0
        }
    }
}

extension UserProfilePresenter: FollowRequestsModuleOutput {
    
    func didAcceptFollowRequest() {
        followersCount += 1
    }
}
