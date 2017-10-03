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
        let sut = LikesListAPI(handle: postHandle, type: .post, likesService: likesService)
        
        // when
        sut.getUsersList(cursor: cursor, limit: limit) { _ in () }
        
        // then
        XCTAssertTrue(likesService.getPostLikesPostHandleCursorLimitCompletionCalled)
        
        let args = likesService.getPostLikesPostHandleCursorLimitCompletionReceivedArguments
        XCTAssertEqual(args?.cursor, cursor)
        XCTAssertEqual(args?.limit, limit)
    }
    
    func testThatCallsCorrectLikersForComment() {
        
        //given
        
        let handle = UUID().uuidString
        let cursor = UUID().uuidString
        let limit = Int(arc4random() % 100)
        let likesService = MockLikesService()
        let commentApi = LikesListAPI(handle: handle, type: .comment, likesService: likesService)
        
        //when
        
        commentApi.getUsersList(cursor: cursor, limit: limit) { _ in () }
        
        //then
        
        XCTAssertTrue(likesService.getCommentsLikesCommentHandleCursorLimitCompletionCalled)
        
        let commentArgs = likesService.getCommentsLikesCommentHandleCursorLimitCompletionReceivedArguments
        XCTAssertEqual(commentArgs?.cursor, cursor)
        XCTAssertEqual(commentArgs?.limit, limit)
    }
    
    func testThatCallsCorrectLikersForReply() {
        
        //given
        
        let handle = UUID().uuidString
        let cursor = UUID().uuidString
        let limit = Int(arc4random() % 100)
        let likesService = MockLikesService()
        let replyApi = LikesListAPI(handle: handle, type: .reply, likesService: likesService)
        
        //when
        
        replyApi.getUsersList(cursor: cursor, limit: limit) { _ in () }
        
        //then
        
        XCTAssertTrue(likesService.getReplyLikesReplyHandleCursorLimitCompletionCalled)
        
        let replyArgs = likesService.getReplyLikesReplyHandleCursorLimitCompletionReceivedArguments
        XCTAssertEqual(replyArgs?.cursor, cursor)
        XCTAssertEqual(replyArgs?.limit, limit)
    }
}
