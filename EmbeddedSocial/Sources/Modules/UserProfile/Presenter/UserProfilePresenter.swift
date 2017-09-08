//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

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
    
    init(userID: String? = nil, myProfileHolder: UserHolder) {
        guard myProfileHolder.me != nil || userID != nil else { fatalError("Either userID or myProfileHolder must be supplied") }
        
        self.userID = userID
        followersCount = 0
        followingCount = 0
        self.myProfileHolder = myProfileHolder
    }
    
    func viewIsReady() {
        view.setupInitialState()
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
        guard let userID = userID else { return }
        
        guard me != nil else {
            router.openLogin()
            return
        }
        
        view.setIsProcessingFollowRequest(true)
        
        let callback = { [weak self] (result: Result<Void>) in
            let status = FollowStatus.reduce(status: followStatus, visibility: self?.user?.visibility ?? ._public)
            self?.processSocialResponse(result.map { status })
        }
        
        interactor.processSocialRequest(currentFollowStatus: followStatus, userID: userID, completion: callback)
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
        var user = self.user
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
        if let user = user {
            router.showUserMenu(
                user,
                blockHandler: { [weak self] in self?.block(user: user) },
                reportHandler: { [weak self] in self?.router.openReport(user: user) }
            )
        } else if let me = me {
            router.showMyMenu { [weak self] in self?.router.openCreatePost(user: me) }
        }
    }
    
    private func block(user: User) {
        view.setIsLoadingUser(true)

        interactor.block(userID: user.uid) { [weak self] result in
            self?.view.setIsLoadingUser(false)
            
            if result.isSuccess {
                // FIXME: decide if full profile reload is needed
                self?.loadUser()
            } else {
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
        feedModuleInput?.feedType = .user(user: uid, scope: scope)
        view.setFilterEnabled(false)
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
