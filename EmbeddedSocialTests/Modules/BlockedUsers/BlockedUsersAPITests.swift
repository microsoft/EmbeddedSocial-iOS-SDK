//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BlockedUsersAPITests: XCTestCase {
    
    func testThatItCallsCorrectSocialServiceMethod() {
        // given
        let socialService = MockSocialService()
        let sut = BlockedUsersAPI(socialService: socialService)
        
        // when
        sut.getUsersList(cursor: nil, limit: 0) { _ in () }
        
        // then
        XCTAssertEqual(socialService.getMyBlockedUsersCount, 1)
    }
}
