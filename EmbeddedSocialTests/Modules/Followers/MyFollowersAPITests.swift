//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MyFollowersAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCallsMyFollowersAPI() {
        // given
        let service = MockSocialService()
        let sut = MyFollowersAPI(service: service)
        
        // when
        sut.getUsersList(cursor: nil, limit: 10) { _ in () }
        
        // then
        XCTAssertEqual(service.getMyFollowersCount, 1)
    }
}
