//
//  UserProfileInteractorTests.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 7/31/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import EmbeddedSocial

class UserProfileInteractorTests: XCTestCase {
    var userService: MockUserService!
    var socialService: MockSocialService!
    var sut: UserProfileInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        socialService = MockSocialService()
        sut = UserProfileInteractor(userService: userService, socialService: socialService)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        socialService = nil
        sut = nil
    }
    
    func testThatFollowIsCalled() {
        sut.follow(userID: UUID().uuidString) { _ in () }
        XCTAssertEqual(socialService.followCount, 1)
    }
    
    func testThatUnfollowIsCalled() {
        sut.unfollow(userID: UUID().uuidString) { _ in () }
        XCTAssertEqual(socialService.unfollowCount, 1)
    }
}

