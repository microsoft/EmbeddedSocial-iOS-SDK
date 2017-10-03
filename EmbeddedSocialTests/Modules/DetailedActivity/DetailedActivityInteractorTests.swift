//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial



class DetailedActivityInteractorTests: XCTestCase {
    var output: MockDetailedActivityPresenter!
    var interactor = DetailedActivityInteractor()
    var repliesService: MockRepliesService!
    var commentService: MockCommentsService!
    
    
    override func setUp() {
        repliesService = MockRepliesService()
        commentService = MockCommentsService()
        
        output = MockDetailedActivityPresenter()
        
        interactor.replyService = repliesService
        interactor.output = output
        interactor.commentService = commentService
        interactor.commentHandle = UUID().uuidString
        interactor.replyHandle = UUID().uuidString
    }
    
    override func tearDown() {
        repliesService = nil
        interactor.output = nil
        commentService = nil
        interactor.commentHandle = nil
        interactor.replyHandle = nil
        output = nil
        
    }
    
    func testThatCommentLoaded() {
        
        //given
        let comment = Comment(commentHandle: UUID().uuidString)
        comment.text = UUID().uuidString
        comment.topicHandle = UUID().uuidString
        
        commentService.getCommentReturnComment = comment
        
        interactor.loadComment()
        
        XCTAssertEqual(output.loadedCommentCount, 1)
    }
    
    func testThatReplyLoaded() {
        
        //given
        let reply = Reply(replyHandle: UUID().uuidString)
        reply.text = UUID().uuidString
        reply.commentHandle = UUID().uuidString
        repliesService.getReplyReturnReply = reply        
        
        interactor.loadReply()
        
        XCTAssertEqual(output.loadedReplyCount, 1)
    }
    
    
}
