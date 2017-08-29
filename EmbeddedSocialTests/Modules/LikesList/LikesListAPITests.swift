//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikesListAPITests: XCTestCase {
    
    func testThatItCallsCorrectSocialServiceMethod() {
        // given
        let postHandle = UUID().uuidString
        let cursor = UUID().uuidString
        let limit = Int(arc4random() % 100)
        let likesService = MockLikesService()
        let sut = LikesListAPI(postHandle: postHandle, likesService: likesService)
        
        // when
        sut.getUsersList(cursor: cursor, limit: limit) { _ in () }
        
        // then
        XCTAssertTrue(likesService.getPostLikes_postHandle_cursor_limit_completion_Called)
        
        let args = likesService.getPostLikes_postHandle_cursor_limit_completion_ReceivedArguments
        XCTAssertEqual(args?.cursor, cursor)
        XCTAssertEqual(args?.limit, limit)
    }
}
