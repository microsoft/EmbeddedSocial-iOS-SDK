//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockLikesService: LikesServiceProtocol {
    
    //MARK: - postLike
    
    var postLike_postHandle_completion_Called = false
    var postLike_postHandle_completion_ReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func postLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        postLike_postHandle_completion_Called = true
        postLike_postHandle_completion_ReceivedArguments = (postHandle: postHandle, completion: completion)
    }
    
    //MARK: - deleteLike
    
    var deleteLike_postHandle_completion_Called = false
    var deleteLike_postHandle_completion_ReceivedArguments: (postHandle: PostHandle, completion: CompletionHandler)?
    
    func deleteLike(postHandle: PostHandle, completion: @escaping CompletionHandler) {
        deleteLike_postHandle_completion_Called = true
        deleteLike_postHandle_completion_ReceivedArguments = (postHandle: postHandle, completion: completion)
    }
    
    //MARK: - likeComment
    
    var likeComment_commentHandle_completion_Called = false
    var likeComment_commentHandle_completion_ReceivedArguments: (commentHandle: String, completion: CommentCompletionHandler)?
    
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) {
        likeComment_commentHandle_completion_Called = true
        likeComment_commentHandle_completion_ReceivedArguments = (commentHandle: commentHandle, completion: completion)
    }
    
    //MARK: - unlikeComment
    
    var unlikeComment_commentHandle_completion_Called = false
    var unlikeComment_commentHandle_completion_ReceivedArguments: (commentHandle: String, completion: CompletionHandler)?
    
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler) {
        unlikeComment_commentHandle_completion_Called = true
        unlikeComment_commentHandle_completion_ReceivedArguments = (commentHandle: commentHandle, completion: completion)
    }
    
    //MARK: - likeReply
    
    var likeReply_replyHandle_completion_Called = false
    var likeReply_replyHandle_completion_ReceivedArguments: (replyHandle: String, completion: ReplyLikeCompletionHandler)?
    
    func likeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        likeReply_replyHandle_completion_Called = true
        likeReply_replyHandle_completion_ReceivedArguments = (replyHandle: replyHandle, completion: completion)
    }
    
    //MARK: - unlikeReply
    
    var unlikeReply_replyHandle_completion_Called = false
    var unlikeReply_replyHandle_completion_ReceivedArguments: (replyHandle: String, completion: ReplyLikeCompletionHandler)?
    
    func unlikeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        unlikeReply_replyHandle_completion_Called = true
        unlikeReply_replyHandle_completion_ReceivedArguments = (replyHandle: replyHandle, completion: completion)
    }
    
    //MARK: - getPostLikes
    
    var getPostLikes_postHandle_cursor_limit_completion_Called = false
    var getPostLikes_postHandle_cursor_limit_completion_ReceivedArguments: (postHandle: String, cursor: String?, limit: Int, completion: (Result<UsersListResponse>) -> Void)?
    
    func getPostLikes(postHandle: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        getPostLikes_postHandle_cursor_limit_completion_Called = true
        getPostLikes_postHandle_cursor_limit_completion_ReceivedArguments = (postHandle: postHandle, cursor: cursor, limit: limit, completion: completion)
    }
    
}
