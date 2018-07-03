//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserFollowingAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCallsUserFollowingAPI() {
        // given
        let userID = UUID().uuidString
        let service = MockSocialService()
        let sut = UserFollowingAPI(userID: userID, service: service)
        
        // when
        sut.getUsersList(cursor: nil, limit: 10) { _ in () }
        
        // then
        XCTAssertEqual(service.getUserFollowingCount, 1)
    }
}
