//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class MockLikeSerivce: LikesServiceProtocol {
    func likeComment(commentHandle: String, completion: @escaping LikesServiceProtocol.CommentCompletionHandler) {
        completion("commentHandle", nil)
    }
    
    func unlikeComment(commentHandle: String, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        completion("commentHandle", nil)
    }
    
    func deleteLike(postHandle: LikesServiceProtocol.PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func postLike(postHandle: LikesServiceProtocol.PostHandle, completion: @escaping LikesServiceProtocol.CompletionHandler) {
        
    }
    
    func likeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        
    }
    
    func unlikeReply(replyHandle: String, completion: @escaping LikesServiceProtocol.ReplyLikeCompletionHandler) {
        
    }
}

class CommentCellInteractorTests: XCTestCase {
    
    var output = MockCommentCellPresenter()
    var interactor = CommentCellInteractor()
    
    var likeService: LikesServiceProtocol?
    
    override func setUp() {
        super.setUp()
        interactor.output = output
        likeService = MockLikeSerivce()
        interactor.likeService = likeService
    }
    
    override func tearDown() {
        super.tearDown()
        interactor.output = nil
    }
    
    
    func testThatCommentLiked() {

        //given
        let comment = Comment()
        comment.commentHandle = "handle"
        comment.text = "text"
        comment.totalLikes = 0
        comment.liked = false
        output.comment = comment

        //when
        interactor.commentAction(commentHandle: comment.commentHandle!, action: .like)

        //then
        XCTAssertEqual(output.comment.totalLikes , 1)
        XCTAssertEqual(output.comment.liked , true)
    }
    
    func testThatCommentUnliked() {

        //given
        let comment = Comment()
        comment.commentHandle = "handle"
        comment.text = "text"
        comment.totalLikes = 1
        comment.liked = true
        output.comment = comment

        //when
        interactor.commentAction(commentHandle: comment.commentHandle!, action: .unlike)

        //then
        XCTAssertEqual(output.comment.totalLikes , 0)
        XCTAssertEqual(output.comment.liked , false)
    }
    
}
