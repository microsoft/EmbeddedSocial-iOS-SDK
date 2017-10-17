//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentsService: CommentServiceProtocol {
    
    //MARK: - fetchComments
    
    var fetchCommentsTopicHandleCursorLimitCachedResultResultHandlerCalled = false
    var fetchCommentsTopicHandleCursorLimitCachedResultResultHandlerReceivedArguments: (topicHandle: String, cursor: String?, limit: Int32?)?
    var fetchCommentsResult: CommentFetchResult!
    
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32?, cachedResult: @escaping CommentFetchResultHandler, resultHandler: @escaping CommentFetchResultHandler) {
        fetchCommentsTopicHandleCursorLimitCachedResultResultHandlerCalled = true
        fetchCommentsTopicHandleCursorLimitCachedResultResultHandlerReceivedArguments = (topicHandle: topicHandle, cursor: cursor, limit: limit)
        resultHandler(fetchCommentsResult)
    }
    
    //MARK: - comment
    
    var commentCommentHandleCachedResultSuccessFailureCalled = false
    var commentCommentHandleCachedResultSuccessFailureReceivedArguments: (commentHandle: String, cachedResult: CommentHandler)?
    var getCommentReturnComment: Comment!
    
    func comment(commentHandle: String, cachedResult: @escaping CommentHandler, success: @escaping CommentHandler, failure: @escaping Failure) {
        commentCommentHandleCachedResultSuccessFailureCalled = true
        commentCommentHandleCachedResultSuccessFailureReceivedArguments = (commentHandle: commentHandle, cachedResult: cachedResult)
        success(getCommentReturnComment)
    }
    
    //MARK: - postComment

    var postCommentCalled = false
    var postCommentReceivedArguments: (comment: Comment, photo: Photo?)?
    var postCommentReturnComment: Comment?
    var postCommentReturnError: Error?
    
    func postComment(comment: Comment, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        postCommentCalled = true
        postCommentReceivedArguments = (comment, photo)
        
        if let comment = postCommentReturnComment {
            resultHandler(comment)
        } else if let error = postCommentReturnError {
            failure(error)
        }
    }
    
    //MARK: - deleteComment
    
    var deleteCommentCompletionCalled = false
    var deleteCommentCompletionReceivedCommentHandle: String?
    var deleteCommentResult: Result<Void>!
    
    func delete(comment: Comment, completion: @escaping ((Result<Void>) -> Void)) {
        deleteCommentCompletionCalled = true
        deleteCommentCompletionReceivedCommentHandle = comment.commentHandle
        completion(.success())
    }
}
