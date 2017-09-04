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
    
    func deleteLike(postHandle: LikesServiceProtocol.PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func postLike(postHandle: LikesServiceProtocol.PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func likeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        completion("replyHandle", nil)
    }
    
    func unlikeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        completion("replyHandle", nil)
    }
}

private class MockRepliesService: RepliesServiceProtcol {

    func reply(replyHandle: String, cachedResult: @escaping ReplyHandler, success: @escaping ReplyHandler, failure: @escaping Failure) {
        let reply = Reply()
        reply.text = "test"
        success(reply)
    }
    
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int, cachedResult: @escaping RepliesFetchResultHandler, resultHandler: @escaping RepliesFetchResultHandler) {
        var result = RepliesFetchResult()
        result.cursor = "cursor"
        result.error = nil
        result.replies = [Reply()]
        resultHandler(result)
    }
    
    func postReply(commentHandle: String, request: PostReplyRequest, success: @escaping PostReplyResultHandler, failure: @escaping Failure) {
        let result = PostReplyResponse()
        result.replyHandle = "handle"
        success(result)
    }
}

class CommentRepliesInteractorTests: XCTestCase {
    
    var output = MockCommentRepliesPresenter()
    var interactor = CommentRepliesInteractor()
    
    var likeService: LikesServiceProtocol?
    var repliesService: RepliesServiceProtcol?
    
    override func setUp() {
        super.setUp()
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
    }
    
    func testThatFetchedReplies() {
        //given
        let comment = Comment()
        comment.commentHandle = "handle"
        output.comment = comment
        //default in MockRepliesService fetching 1 item
        
        //when
        interactor.fetchReplies(commentHandle: comment.commentHandle, cursor: "test", limit: 10)
        
        //then
        XCTAssertEqual(output.fetchedRepliesCount , 1)
        
    }
    
    func testThatFetchedMoreReplies() {
        //given
        //default in MockRepliesService fetching 1 item
        
        //when
        interactor.fetchReplies(commentHandle: "test", cursor: "test", limit: 10)
        
        //then
        XCTAssertEqual(output.fetchedRepliesCount , 1)
        
    }
    
    
    func testThatCommentLiked() {
        
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
    
    func testThatCommentUnliked() {
        
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
        let reply = "test"
        
        //when
        interactor.postReply(commentHandle: "handle", text: "test")
        
        //then
        XCTAssertEqual(output.postedReply?.text, reply)
        
    }
    
}
