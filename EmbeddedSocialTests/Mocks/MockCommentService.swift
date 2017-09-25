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
    
    var postCommentTopicHandleRequestPhotoResultHandlerFailureCalled = false
    var postCommentTopicHandleRequestPhotoResultHandlerFailureReceivedArguments: (topicHandle: String, request: PostCommentRequest, photo: Photo?)?
    var postCommentReturnResponse: PostCommentResponse?
    var postCommentReturnError: Error?
    
    func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        postCommentTopicHandleRequestPhotoResultHandlerFailureCalled = true
        postCommentTopicHandleRequestPhotoResultHandlerFailureReceivedArguments = (topicHandle: topicHandle, request: request, photo: photo)
        if let response = postCommentReturnResponse {
            resultHandler(response)
        } else if let error = postCommentReturnError {
            failure(error)
        }
    }
    
    
    func postComment(comment: Comment, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        let response = PostCommentResponse()
        response.commentHandle = "commentHandle"
        resultHandler(response)
    }
    
    //MARK: - deleteComment
    
    var deleteCommentCommentHandleCompletionCalled = false
    var deleteCommentCommentHandleCompletionReceivedCommentHandle: String?
    var deleteCommentResult: Result<Void>!
    
    func deleteComment(commentHandle: String, completion: @escaping ((Result<Void>) -> Void)) {
        deleteCommentCommentHandleCompletionCalled = true
        deleteCommentCommentHandleCompletionReceivedCommentHandle = commentHandle
        completion(deleteCommentResult)
    }
}
