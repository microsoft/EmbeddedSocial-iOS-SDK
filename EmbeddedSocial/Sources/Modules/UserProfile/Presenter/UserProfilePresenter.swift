//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserProfilePresenter: UserProfileViewOutput {
    
    weak var view: UserProfileViewInput!
    var router: UserProfileRouterInput!
    var interactor: UserProfileInteractorInput!
    
    private let userID: String?
    private var user: User?
    private let me: User
    private var followersCount = 0
    
    init(userID: String? = nil, me: User) {
        self.userID = userID
        self.me = me
    }

    func viewIsReady() {
        view.setupInitialState()
        
        if userID != nil {
            loadUser()
        } else {
            view.setUser(me)
        }
        
        loadFeed()
    }
    
    private func loadUser() {
        guard let userID = userID else {
            return
        }
        
        view.setIsLoading(true)
        
        interactor.getUser(userID: userID) { [weak self] result in
            self?.view.setIsLoading(false)
            
            if let user = result.value {
                self?.user = user
                self?.followersCount = user.followersCount
                self?.view.setUser(user)
            } else {
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
    
    private func loadFeed() {
        
    }
    
    func onEdit() {
        router.openEditProfile(user: me)
    }
    
    func onFollowing() {
        router.openFollowing(user: user ?? me)
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
            updateFollowersCount(with: status)
        } else {
            view.showError(response.error ?? APIError.unknown)
        }
    }
    
    private func updateFollowersCount(with status: FollowStatus) {
        if status == .accepted {
            followersCount += 1
        } else if status == .empty || status == .blocked {
            followersCount = max(0, followersCount - 1)
        }
        view.setFollowersCount(followersCount)
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
        router.openFollowers(user: user ?? me)
    }
    
    func onMore() {
        if let user = user {
            router.showUserMenu(
                user,
                blockHandler: { [weak self] in self?.block(user: user) },
                reportHandler: { [weak self] in self?.router.openReport(user: user) }
            )
        } else {
            let me = self.me
            router.showMyMenu { [weak self] in self?.router.openCreatePost(user: me) }
        }
    }
    
    private func block(user: User) {
        view.setIsLoading(true)

        interactor.block(userID: user.uid) { [weak self] result in
            self?.view.setIsLoading(false)
            
            if result.isSuccess {
                // FIXME: decide if full profile reload is needed
                self?.loadUser()
            } else {
                self?.view.showError(result.error ?? APIError.unknown)
            }
        }
    }
}
