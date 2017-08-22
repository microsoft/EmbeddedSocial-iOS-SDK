//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class SuggestedUsersAPITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCallsCorrectServiceAPI() {
        // given
        let socialService = MockSocialService()
        let sut = SuggestedUsersAPI(socialService: socialService)
        
        // when
        sut.getUsersList(cursor: nil, limit: 0) { _ in () }
        
        // then
        XCTAssertEqual(socialService.getSuggestedUsersCount, 1)
    }
}
