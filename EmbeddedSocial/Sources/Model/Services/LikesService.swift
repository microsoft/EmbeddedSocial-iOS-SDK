//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LikesServiceProtocol {

    typealias CompletionHandler = (_ postHandle: PostHandle, _ error: Error?) -> Void
    typealias CommentCompletionHandler = (_ commentHandle: String, _ error: Error?) -> Void
    typealias ReplyLikeCompletionHandler = (_ commentHandle: String, _ error: Error?) -> Void

    func postPin(post: Post, completion: @escaping CompletionHandler)
    func deletePin(post: Post, completion: @escaping CompletionHandler)

    func postLike(post: Post, completion: @escaping CompletionHandler)
    func deleteLike(post: Post, completion: @escaping CompletionHandler)
    
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler)
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler)
    func likeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler)
    func unlikeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler)
    func getPostLikes(postHandle: String, cursor: String?, limit: Int,
                      completion: @escaping (Result<UsersListResponse>) -> Void)
    func getCommentLikes(commentHandle: String, cursor: String?, limit: Int,
                         completion: @escaping (Result<UsersListResponse>) -> Void)
    func getReplyLikes(replyHandle: String, cursor: String?, limit: Int,
                       completion: @escaping (Result<UsersListResponse>) -> Void)
}

//MARK: - Optional methods

extension LikesServiceProtocol {
    
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) { }
    
    func unlikeComment(commentHandle: String, completion: @escaping CompletionHandler) { }
    
    func likeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) { }
    
    func unlikeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) { }
    
    func getPostLikes(postHandle: String, cursor: String?, limit: Int,
                      completion: @escaping (Result<UsersListResponse>) -> Void) { }
    
    func getCommentLikes(commentHandle: String, cursor: String?, limit: Int,
                         completion: @escaping (Result<UsersListResponse>) -> Void) {}
    
    func getReplyLikes(replyHandle: String, cursor: String?, limit: Int,
                       completion: @escaping (Result<UsersListResponse>) -> Void) { }
}

class LikesService: BaseService, LikesServiceProtocol {
    
    private var requestExecutor: UsersFeedRequestExecutor!
    private var outgoingActionsExecutor: OutgoingActionRequestExecutor!

    init(executorProvider provider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        super.init()
        requestExecutor = provider.makeUsersFeedExecutor(for: self)
        outgoingActionsExecutor = provider.makeOutgoingActionRequestExecutor(for: self)
    }
    func postLike(post: Post, completion: @escaping CompletionHandler) {
        let builder = LikesAPI.topicLikesPostLikeWithRequestBuilder(topicHandle: post.topicHandle, authorization: authorization)
        let command = LikeTopicCommand(topic: post)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(post.topicHandle, result.error)
        }
    }
    
    func deleteLike(post: Post, completion: @escaping CompletionHandler) {
        let builder = LikesAPI.topicLikesDeleteLikeWithRequestBuilder(topicHandle: post.topicHandle, authorization: authorization)
        let command = UnlikeTopicCommand(topic: post)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(post.topicHandle, result.error)
        }
    }
    
    func likeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) {
        let comment = Comment(commentHandle: commentHandle)
        let command = LikeCommentCommand(comment: comment)
        let builder = LikesAPI.commentLikesPostLikeWithRequestBuilder(commentHandle: commentHandle,
                                                                      authorization: authorization)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(commentHandle, result.error)
        }
    }
    
    func unlikeComment(commentHandle: String, completion: @escaping CommentCompletionHandler) {
        let comment = Comment(commentHandle: commentHandle)
        let command = UnlikeCommentCommand(comment: comment)
        let builder = LikesAPI.commentLikesDeleteLikeWithRequestBuilder(commentHandle: commentHandle,
                                                                        authorization: authorization)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(commentHandle, result.error)
        }
    }
    
    func likeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        let reply = Reply(replyHandle: replyHandle)
        let command = LikeReplyCommand(reply: reply)
        let builder = LikesAPI.replyLikesPostLikeWithRequestBuilder(replyHandle: replyHandle, authorization: authorization)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(replyHandle, result.error)
        }
    }
    
    func unlikeReply(replyHandle: String, completion: @escaping ReplyLikeCompletionHandler) {
        let reply = Reply(replyHandle: replyHandle)
        let command = UnlikeReplyCommand(reply: reply)
        let builder = LikesAPI.replyLikesDeleteLikeWithRequestBuilder(replyHandle: replyHandle, authorization: authorization)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(replyHandle, result.error)
        }
    }
    
    func getPostLikes(postHandle: String, cursor: String?, limit: Int,
                      completion: @escaping (Result<UsersListResponse>) -> Void) {
        
        let builder = LikesAPI.topicLikesGetLikesWithRequestBuilder(
            topicHandle: postHandle,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit))
        
        requestExecutor.execute(with: builder, completion: completion)
    }
    
    func getCommentLikes(commentHandle: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = LikesAPI.commentLikesGetLikesWithRequestBuilder(
            commentHandle: commentHandle,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit))
        
        requestExecutor.execute(with: builder, completion: completion)
    }
    
    func getReplyLikes(replyHandle: String, cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void) {
        let builder = LikesAPI.replyLikesGetLikesWithRequestBuilder(
            replyHandle: replyHandle,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit))
        
        requestExecutor.execute(with: builder, completion: completion)
    }
    
    func postPin(post: Post, completion: @escaping CompletionHandler) {
        let request = PostPinRequest()
        request.topicHandle = post.topicHandle
        
        let builder = PinsAPI.myPinsPostPinWithRequestBuilder(request: request, authorization: authorization)
        let command = PinTopicCommand(topic: post)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(post.topicHandle, result.error)
        }
    }
    
    func deletePin(post: Post, completion: @escaping CompletionHandler) {
        let builder = PinsAPI.myPinsDeletePinWithRequestBuilder(topicHandle: post.topicHandle, authorization: authorization)
        let command = UnpinTopicCommand(topic: post)
        outgoingActionsExecutor.execute(command: command, builder: builder) { result in
            completion(post.topicHandle, result.error)
        }
    }
}

