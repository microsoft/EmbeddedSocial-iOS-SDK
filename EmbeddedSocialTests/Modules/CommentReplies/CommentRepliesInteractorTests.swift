//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class MockLikeSerivce: LikesServiceProtocol {
    func likeComment(commentHandle: String, completion: @escaping LikesServiceProtocol.CommentCompletionHandler) {
        
    }
    
    func unlikeComment(commentHandle: String, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func deleteLike(postHandle: PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func postLike(postHandle: PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func likeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        completion("replyHandle", nil)
    }
    
    func unlikeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        completion("replyHandle", nil)
    }
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler) {}
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler) {}
}

class CommentRepliesInteractorTests: XCTestCase {
    
    var output: MockCommentRepliesPresenter!
    var interactor = CommentRepliesInteractor()
    var myProfileHolder: MyProfileHolder!
    
    var likeService: LikesServiceProtocol?
    var repliesService: MockRepliesService!
    
    override func setUp() {
        super.setUp()
        myProfileHolder = MyProfileHolder()
        output = MockCommentRepliesPresenter(myProfileHolder: myProfileHolder)
        output.interactor = interactor
        interactor.output = output
        
        likeService = MockLikeSerivce()
        interactor.likeService = likeService
        
        repliesService = MockRepliesService()
        interactor.repliesService = repliesService
        
        
    }
    
    override func tearDown() {
        super.tearDown()
        output.interactor = nil
        interactor.output = nil
        likeService = nil
        repliesService = nil
        myProfileHolder = nil
        output = nil
    }
    
    func testThatFetchedReplies() {
        //given
        let comment = Comment()
        comment.commentHandle = "handle"
        output.comment = comment
        
        var result = RepliesFetchResult()
        result.replies = [Reply()]
        repliesService.fetchRepliesReturnResult = result
        //default in MockRepliesService fetching 1 item
        
        //when
        interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: "test", limit: 10)
        
        //then
        XCTAssertEqual(output.fetchedRepliesCount , 1)
        
    }
    
    func testThatFetchedMoreReplies() {
        //given
        //default in MockRepliesService fetching 1 item
        var result = RepliesFetchResult()
        result.replies = [Reply()]
        repliesService.fetchRepliesReturnResult = result
        
        //when
        interactor.fetchReplies(commentHandle: "test", cursor: "test", limit: 10)
        
        //then
        XCTAssertEqual(output.fetchedRepliesCount , 1)
        
    }
    
    
    func testThatReplyLiked() {
        
        //given
        let reply = Reply()
        reply.replyHandle = "handle"
        reply.text = "text"
        reply.totalLikes = 0
        reply.liked = false
        output.replies = [reply]
        
        //when
        interactor.replyAction(replyHandle: reply.replyHandle!, action: .like)
        
        //then
        XCTAssertEqual(output.replies.first?.totalLikes , 1)
        XCTAssertEqual(output.replies.first?.liked , true)
    }
    
    func testThatReplyUnliked() {
        
        //given
        let reply = Reply()
        reply.replyHandle = "handle"
        reply.text = "text"
        reply.totalLikes = 1
        reply.liked = true
        output.replies = [reply]
        
        //when
        interactor.replyAction(replyHandle: reply.replyHandle!, action: .unlike)
        
        //then
        XCTAssertEqual(output.replies.first?.totalLikes , 0)
        XCTAssertEqual(output.replies.first?.liked , false)
    }
    
    func testThatReplyPosted() {
        
        //given
        let reply = Reply(replyHandle: UUID().uuidString)
        reply.text = UUID().uuidString
        reply.commentHandle = UUID().uuidString
        
        let response = PostReplyResponse()
        response.replyHandle = reply.replyHandle
        
        repliesService.postReplyReturnResponse = response
        repliesService.getReplyReturnReply = reply
        
        //when
        interactor.postReply(commentHandle: reply.commentHandle, text: reply.text!)
        
        //then
        XCTAssertEqual(output.postedReply?.text, reply.text)
        
    }
    
}
