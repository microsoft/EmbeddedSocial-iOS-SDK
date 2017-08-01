//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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

