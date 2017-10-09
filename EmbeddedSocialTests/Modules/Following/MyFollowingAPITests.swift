//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class MyFollowingAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCallsMyFollowingAPI() {
        // given
        let service = MockSocialService()
        let sut = MyFollowingAPI(service: service)
        
        // when
        sut.getUsersList(cursor: nil, limit: 10) { _ in () }
        
        // then
        XCTAssertEqual(service.getMyFollowingCount, 1)
    }
}
