//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReplyCellInteractorTests: XCTestCase {
    
    var output: MockReplyCellPresenter!
    var interactor: ReplyCellInteractor!
    
    var likeService: MockLikesService!
    
    override func setUp() {
        super.setUp()
        output = MockReplyCellPresenter()
        interactor = ReplyCellInteractor()
        interactor.output = output
        likeService = MockLikesService()
        interactor.likeService = likeService
    }
    
    override func tearDown() {
        super.tearDown()
        interactor.output = nil
        likeService = nil
    }
    
    
    func testThatReplyLiked() {
        
        //given
        let reply = Reply()
        reply.replyHandle = "handle"
        reply.text = "text"
        reply.totalLikes = 0
        reply.liked = false
        output.reply = reply
        
        likeService.likeReplyReplyHandleCompletionReturnValue = (reply.replyHandle!, nil)
        
        //when
        interactor.replyAction(replyHandle: reply.replyHandle!, action: .like)
        
        //then
        XCTAssertEqual(output.reply?.totalLikes , 1)
        XCTAssertEqual(output.reply?.liked , true)
    }
    
    func testThatReplyUnliked() {
        
        //given
        let reply = Reply()
        reply.replyHandle = "handle"
        reply.text = "text"
        reply.totalLikes = 1
        reply.liked = true
        output.reply = reply
        
        likeService.unlikeReplyReplyHandleCompletionReturnValue = (reply.replyHandle!, nil)
        
        //when
        interactor.replyAction(replyHandle: reply.replyHandle!, action: .unlike)
        
        //then
        XCTAssertEqual(output.reply?.totalLikes , 0)
        XCTAssertEqual(output.reply?.liked , false)
    }
    
}
