//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockLikesService: LikesServiceProtocol {
    
    //MARK: - postPin
    
    var postPinPostHandleCompletionCalled = false
    var postPinPostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func postPin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        postPinPostHandleCompletionCalled = true
        postPinPostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
        completion(postHandle, nil)
    }
    
    //MARK: - deletePin
    
    var deletePinPostHandleCompletionCalled = false
    var deletePinPostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        deletePinPostHandleCompletionCalled = true
        deletePinPostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
        completion(postHandle, nil)
    }
    
    //MARK: - postLike
    
    var postLikePostHandleCompletionCalled = false
    var postLikePostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func postLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        postLikePostHandleCompletionCalled = true
        postLikePostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
        completion(postHandle, nil)
    }
    
    //MARK: - deleteLike
    
    var deleteLikePostHandleCompletionCalled = false
    var deleteLikePostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func deleteLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        deleteLikePostHandleCompletionCalled = true
        deleteLikePostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
        completion(postHandle, nil)
    }
    
    //MARK: - likeComment
    
    var likeCommentCommentHandleCompletionCalled = false
    var likeCommentCommentHandleCompletionReceivedArguments: (commentHandle: String, completion: CommentCompletionHandler)?
    var likeCommentCommentHandleCompletionReturnValue: (String, Error?)!

    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) {
        likeCommentCommentHandleCompletionCalled = true
        likeCommentCommentHandleCompletionReceivedArguments = (commentHandle: commentHandle, completion: completion)
        completion(likeCommentCommentHandleCompletionReturnValue!.0, likeCommentCommentHandleCompletionReturnValue!.1)
    }
    
    //MARK: - unlikeComment
    
    var unlikeCommentCommentHandleCompletionCalled = false
    var unlikeCommentCommentHandleCompletionReceivedArguments: (commentHandle: String, completion: CompletionHandler)?
    var unlikeCommentCommentHandleCompletionReturnValue: (String, Error?)!
    
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler) {
        unlikeCommentCommentHandleCompletionCalled = true
        unlikeCommentCommentHandleCompletionReceivedArguments = (commentHandle: commentHandle, completion: completion)
        completion(unlikeCommentCommentHandleCompletionReturnValue!.0, unlikeCommentCommentHandleCompletionReturnValue!.1)
    }
    
    //MARK: - likeReply
    
    var likeReplyReplyHandleCompletionCalled = false
    var likeReplyReplyHandleCompletionReceivedArguments: (replyHandle: String, completion: ReplyLikeCompletionHandler)?
    var likeReplyReplyHandleCompletionReturnValue: (String, Error?)!
    
    func likeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        likeReplyReplyHandleCompletionCalled = true
        likeReplyReplyHandleCompletionReceivedArguments = (replyHandle: replyHandle, completion: completion)
        completion(likeReplyReplyHandleCompletionReturnValue!.0, likeReplyReplyHandleCompletionReturnValue!.1)
    }
    
    //MARK: - unlikeReply
    
    var unlikeReplyReplyHandleCompletionCalled = false
    var unlikeReplyReplyHandleCompletionReceivedArguments: (replyHandle: String, completion: ReplyLikeCompletionHandler)?
    var unlikeReplyReplyHandleCompletionReturnValue: (String, Error?)!

    func unlikeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        unlikeReplyReplyHandleCompletionCalled = true
        unlikeReplyReplyHandleCompletionReceivedArguments = (replyHandle: replyHandle, completion: completion)
        completion(unlikeReplyReplyHandleCompletionReturnValue!.0, unlikeReplyReplyHandleCompletionReturnValue!.1)
    }
    
    //MARK: - getPostLikes
    
    var getPostLikesPostHandleCursorLimitCompletionCalled = false
    var getPostLikesPostHandleCursorLimitCompletionReceivedArguments: (postHandle: String, cursor: String?, limit: Int, completion: (Result<UsersListResponse>) -> Void)?
    
    func getPostLikes(postHandle: String, cursor: String?, limit: Int,                      completion: @escaping (Result<UsersListResponse>) -> Void) {
        getPostLikesPostHandleCursorLimitCompletionCalled = true
        getPostLikesPostHandleCursorLimitCompletionReceivedArguments = (postHandle: postHandle, cursor: cursor, limit: limit, completion: completion)
    }
    
    //MARK: - getCommentsLikes
    
    var getCommentsLikesCommentHandleCursorLimitCompletionCalled = false
    var getCommentsLikesCommentHandleCursorLimitCompletionReceivedArguments: (commentHandle: String, cursor: String?, limit: Int, completion: (Result<UsersListResponse>) -> Void)?

    func getCommentLikes(commentHandle: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getCommentsLikesCommentHandleCursorLimitCompletionCalled = true
        getCommentsLikesCommentHandleCursorLimitCompletionReceivedArguments = (commentHandle: commentHandle, cursor: cursor, limit: limit, completion: completion)
    }
    
    //MARK: - getRepliesLikes
    
    var getReplyLikesReplyHandleCursorLimitCompletionCalled = false
    var getReplyLikesReplyHandleCursorLimitCompletionReceivedArguments: (replyHandle: String, cursor: String?, limit: Int, completion: (Result<UsersListResponse>) -> Void)?
    
    func getReplyLikes(replyHandle: String, cursor: String?, limit: Int,                      completion: @escaping (Result<UsersListResponse>) -> Void) {
        getReplyLikesReplyHandleCursorLimitCompletionCalled = true
        getReplyLikesReplyHandleCursorLimitCompletionReceivedArguments = (replyHandle: replyHandle, cursor: cursor, limit: limit, completion: completion)
    }
    
}
