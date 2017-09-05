//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserProfileRouter: UserProfileRouterInput {
    private(set) var openFollowersCount = 0
    private(set) var openFollowingCount = 0
    private(set) var openEditProfileCount = 0
    private(set) var openCreatePostCount = 0
    private(set) var showMyMenuCount = 0
    private(set) var showUserMenuCount = 0
    private(set) var openReportCount = 0
    private(set) var popTopScreenCount = 0
    private(set) var openLoginCount = 0

    func openFollowers(user: User) {
        openFollowersCount += 1
    }
    
    func openFollowing(user: User) {
        openFollowingCount += 1
    }
    
    func openEditProfile(user: User) {
        openEditProfileCount += 1
    }
    
    func openCreatePost(user: User) {
        openCreatePostCount += 1
    }
    
    func showMyMenu(_ addPostHandler: @escaping () -> Void) {
        showMyMenuCount += 1
    }
    
    func showUserMenu(_ user: User, blockHandler: @escaping () -> Void, reportHandler: @escaping () -> Void) {
        showUserMenuCount += 1
    }
    
    func openReport(user: User) {
        openReportCount += 1
    }
    
    func popTopScreen() {
        popTopScreenCount += 1
    }
    
    func openLogin() {
        openLoginCount += 1
    }
}

