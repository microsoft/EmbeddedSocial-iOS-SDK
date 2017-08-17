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
    
    func testThatSocialRequestIsCalledForEmptyStatus() {
        sut.processSocialRequest(currentFollowStatus: .empty, userID: UUID().uuidString) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatSocialRequestIsCalledForAcceptedStatus() {
        sut.processSocialRequest(currentFollowStatus: .accepted, userID: UUID().uuidString) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatSocialRequestIsCalledForPendingStatus() {
        sut.processSocialRequest(currentFollowStatus: .pending, userID: UUID().uuidString) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatSocialRequestIsCalledForBlockedStatus() {
        sut.processSocialRequest(currentFollowStatus: .blocked, userID: UUID().uuidString) { _ in () }
        XCTAssertEqual(socialService.requestCount, 1)
    }
    
    func testThatUserIsLoadedFromCache() {
        _ = sut.cachedUser(with: "")
        XCTAssertEqual(cache.firstIncomingCount, 1)
    }
}

