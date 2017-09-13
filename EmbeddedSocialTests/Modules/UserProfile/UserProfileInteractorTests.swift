//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserProfileInteractorTests: XCTestCase {
    var userService: MockUserService!
    var socialService: MockSocialService!
    var cache: MockCache!
    var sut: UserProfileInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        socialService = MockSocialService()
        cache = MockCache()
        sut = UserProfileInteractor(userService: userService, socialService: socialService, cache: cache)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        socialService = nil
        cache = nil
        sut = nil
    }
    
    func testThatGetUserIsCalled() {
        // given
        let userID = UUID().uuidString
        
        // when
        sut.getUser(userID: userID) { _ in () }
        
        // then
        XCTAssertEqual(userService.getUserProfileCount, 1)
    }
    
    func testThatItProcessesSocialRequest() {
        // given
        let user = User(visibility: ._public, followerStatus: .empty)
        
        // when
        sut.processSocialRequest(to: user) { _ in () }
        
        // then
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatSocialRequestIsCalledForAcceptedStatus() {
        let user = User()
        sut.processSocialRequest(to: user) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatSocialRequestIsCalledForPendingStatus() {
        let user = User()
        sut.processSocialRequest(to: user) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatSocialRequestIsCalledForBlockedStatus() {
        let user = User()
        sut.processSocialRequest(to: user) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatUserIsLoadedFromCache() {
        _ = sut.cachedUser(with: "")
        XCTAssertTrue(cache.firstIncoming_ofType_handle_Called)
    }
}

