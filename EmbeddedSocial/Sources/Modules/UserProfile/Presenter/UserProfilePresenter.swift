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
    
    private let userID: String?
    fileprivate var user: User?
    fileprivate var me: User?
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
        self.me = myProfileHolder.me
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
                self?.me = $0
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
        guard let userID = userID else {
            return
        }
        
        view.setIsProcessingFollowRequest(true)
        
        let callback = { [unowned self] (result: Result<Void>) in
            let status = FollowStatus.reduce(status: followStatus, visibility: self.user?.visibility ?? ._public)
            self.processSocialResponse(self.transform(result: result)(status))
        }
        
        interactor.processSocialRequest(currentFollowStatus: followStatus, userID: userID, completion: callback)
    }
    
    private func processSocialResponse(_ response: Result<FollowStatus>) {
        view.setIsProcessingFollowRequest(false)

        if let status = response.value {
            view.setFollowStatus(status)
            followersCount = updatedFollowCount(followersCount, with: status)
        } else {
            view.showError(response.error ?? APIError.unknown)
        }
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
    
    private func transform(result: Result<Void>) -> (FollowStatus) -> Result<FollowStatus> {
        return { status in
            if result.isSuccess {
                return .success(status)
            } else {
                return .failure(result.error ?? APIError.unknown)
            }
        }
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
        feedModuleInput?.setFeed(.user(user: uid, scope: scope))
        feedModuleInput?.refreshData()
        view.setFilterEnabled(false)
    }
}

extension UserProfilePresenter: FeedModuleOutput {
    
    func didScrollFeed(_ feedView: UIScrollView) {
        let isHeaderVisible = feedView.contentOffset.y < UserProfilePresenter.headerHeight - Constants.UserProfile.filterHeight
        view.setStickyFilterHidden(isHeaderVisible)
    }
    
    func didFinishRefreshingData(_ error: Error?) {
        view.setFilterEnabled(true)
    }
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
    
    func didCreatePost() {
        feedModuleInput?.refreshData()
    }
}

extension UserProfilePresenter: EditProfileModuleOutput {
    
    func onProfileEdited(me: User) {
        router.popTopScreen()
        setUser(me) { [weak self] in
            self?.me = $0
            self?.myProfileHolder?.me = $0
        }
    }
}
