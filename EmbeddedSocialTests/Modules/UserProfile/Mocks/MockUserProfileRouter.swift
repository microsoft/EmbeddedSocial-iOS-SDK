//
//  MockUserProfileRouter.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 7/31/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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

