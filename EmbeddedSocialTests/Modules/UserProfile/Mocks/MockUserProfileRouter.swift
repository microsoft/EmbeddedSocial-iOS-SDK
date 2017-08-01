//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserProfileRouter: UserProfileRouterInput {
    private(set) var openFollowersCount = 0
    private(set) var openFollowingCount = 0
    private(set) var openEditProfileCount = 0

    func openFollowers(user: User) {
        openFollowersCount += 1
    }
    
    func openFollowing(user: User) {
        openFollowingCount += 1
    }
    
    func openEditProfile(user: User) {
        openEditProfileCount += 1
    }
}

