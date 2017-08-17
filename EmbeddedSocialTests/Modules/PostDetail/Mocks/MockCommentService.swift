//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentService: CommentsService {
    
    var commentText = ""
    
    override func fetchComments(topicHandle: String, cursor: String?, limit: Int32?, resultHandler: @escaping CommentFetchResultHandler) {
        resultHandler(CommentFetchResult(comments: [Comment()], error: nil, cursor: nil))
    }
    
    override func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        commentText = request.text!
        postComment(topicHandle: topicHandle, request: request, success: resultHandler, failure: failure)
    }
    
    override func postComment(topicHandle: String, request: PostCommentRequest, success: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        let response = PostCommentResponse()
        response.commentHandle = "commentHandle"
        success(response)
    }
    
    override func comment(commentHandle: String, success: @escaping CommentHandler, failure: @escaping Failure) {
        let comment = Comment()
        comment.commentHandle = commentHandle
        comment.text = commentText
        success(comment)
    }
}
