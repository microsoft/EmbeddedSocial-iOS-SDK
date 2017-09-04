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
    }
    
    //MARK: - deletePin
    
    var deletePinPostHandleCompletionCalled = false
    var deletePinPostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func deletePin(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        deletePinPostHandleCompletionCalled = true
        deletePinPostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
    }
    
    //MARK: - postLike
    
    var postLikePostHandleCompletionCalled = false
    var postLikePostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func postLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        postLikePostHandleCompletionCalled = true
        postLikePostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
    }
    
    //MARK: - deleteLike
    
    var deleteLikePostHandleCompletionCalled = false
    var deleteLikePostHandleCompletionReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func deleteLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        deleteLikePostHandleCompletionCalled = true
        deleteLikePostHandleCompletionReceivedArguments = (postHandle: postHandle, completion: completion)
    }
    
    //MARK: - likeComment
    
    var likeCommentCommentHandleCompletionCalled = false
    var likeCommentCommentHandleCompletionReceivedArguments: (commentHandle: String, completion: CommentCompletionHandler)?
    
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) {
        likeCommentCommentHandleCompletionCalled = true
        likeCommentCommentHandleCompletionReceivedArguments = (commentHandle: commentHandle, completion: completion)
    }
    
    //MARK: - unlikeComment
    
    var unlikeCommentCommentHandleCompletionCalled = false
    var unlikeCommentCommentHandleCompletionReceivedArguments: (commentHandle: String, completion: CompletionHandler)?
    
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler) {
        unlikeCommentCommentHandleCompletionCalled = true
        unlikeCommentCommentHandleCompletionReceivedArguments = (commentHandle: commentHandle, completion: completion)
    }
    
    //MARK: - likeReply
    
    var likeReplyReplyHandleCompletionCalled = false
    var likeReplyReplyHandleCompletionReceivedArguments: (replyHandle: String, completion: ReplyLikeCompletionHandler)?
    
    func likeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        likeReplyReplyHandleCompletionCalled = true
        likeReplyReplyHandleCompletionReceivedArguments = (replyHandle: replyHandle, completion: completion)
    }
    
    //MARK: - unlikeReply
    
    var unlikeReplyReplyHandleCompletionCalled = false
    var unlikeReplyReplyHandleCompletionReceivedArguments: (replyHandle: String, completion: ReplyLikeCompletionHandler)?
    
    func unlikeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        unlikeReplyReplyHandleCompletionCalled = true
        unlikeReplyReplyHandleCompletionReceivedArguments = (replyHandle: replyHandle, completion: completion)
    }
    
    //MARK: - getPostLikes
    
    var getPostLikesPostHandleCursorLimitCompletionCalled = false
    var getPostLikesPostHandleCursorLimitCompletionReceivedArguments: (postHandle: String, cursor: String?, limit: Int, completion: (Result<UsersListResponse>) -> Void)?
    
    func getPostLikes(postHandle: String, cursor: String?, limit: Int,                      completion: @escaping (Result<UsersListResponse>) -> Void) {
        getPostLikesPostHandleCursorLimitCompletionCalled = true
        getPostLikesPostHandleCursorLimitCompletionReceivedArguments = (postHandle: postHandle, cursor: cursor, limit: limit, completion: completion)
    }
    
}
