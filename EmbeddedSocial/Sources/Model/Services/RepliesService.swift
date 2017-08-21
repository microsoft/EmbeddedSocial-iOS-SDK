//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias RepliesFetchResultHandler = ((RepliesFetchResult) -> Void)
typealias PostReplyResultHandler = ((PostReplyResponse) -> Void)

enum RepliesServiceError: Error {
    case failedToFetch(message: String)
    case failedToLike(message: String)
    case failedToUnLike(message: String)
    
    var message: String {
        switch self {
        case .failedToFetch(let message),
             .failedToLike(let message),
             .failedToUnLike(let message):
            return message
        }
    }
}

protocol RepliesServiceProtcol {
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int, resultHandler: @escaping RepliesFetchResultHandler)
    func postReply(commentHandle: String, request: PostReplyRequest, success: @escaping PostReplyResultHandler, failure: @escaping Failure)
    func reply(replyHandle: String, success: @escaping ((Reply) -> Void), failure: Failure) 
}

class RepliesService: BaseService, RepliesServiceProtcol {
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int, resultHandler: @escaping RepliesFetchResultHandler) {
        RepliesAPI.commentRepliesGetReplies(commentHandle: commentHandle, authorization: authorization, cursor: cursor, limit: Int32(limit)) { (response, error) in
            var result = RepliesFetchResult()
            
            guard error == nil else {
                result.error = RepliesServiceError.failedToFetch(message: error!.localizedDescription)
                resultHandler(result)
                return
            }
            
            guard let data = response?.data else {
                result.error = RepliesServiceError.failedToFetch(message: L10n.Error.noItemsReceived)
                resultHandler(result)
                return
            }
            
            result.replies = self.convert(data: data)
            result.cursor = response?.cursor
            
            resultHandler(result)
        }
    }
    
    func reply(replyHandle: String, success: @escaping ((Reply) -> Void), failure: Failure) {
        RepliesAPI.repliesGetReply(replyHandle: replyHandle, authorization: authorization) { (replyView, error) in
            if error != nil {
                self.errorHandler.handle(error)
            } else {
                success(self.convert(data: [replyView!]).first!)
            }
        }
    }
    
    func postReply(commentHandle: String, request: PostReplyRequest, success: @escaping PostReplyResultHandler, failure: @escaping Failure) {
        RepliesAPI.commentRepliesPostReply(commentHandle: commentHandle, request: request, authorization: authorization) { (response, error) in
            if response != nil {
                success(response!)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
            }
        }
    }
    
    private func convert(data: [ReplyView]) -> [Reply] {
        var replies = [Reply]()
        for replyView in data {
            let reply = Reply()
            reply.commentHandle = replyView.commentHandle
            reply.text = replyView.text
            reply.liked = replyView.liked ?? false
            reply.replyHandle = replyView.replyHandle
            reply.topicHandle = replyView.topicHandle
            reply.createdTime = replyView.createdTime
            reply.lastUpdatedTime = replyView.lastUpdatedTime
            reply.userFirstName = replyView.user?.firstName
            reply.userLastName = replyView.user?.lastName
            reply.userPhotoUrl = replyView.user?.photoUrl
            reply.userHandle = replyView.user?.userHandle
            reply.totalLikes = Int(replyView.totalLikes!)
            replies.append(reply)
        }
        return replies
    }
}

class Reply {
    var userHandle: String?
    var userFirstName: String?
    var userLastName: String?
    var userPhotoUrl: String?
    
    var text: String?
    var totalLikes: Int = 0
    var liked = false
    
    var replyHandle: String?
    var commentHandle: String?
    var topicHandle: String?
    var createdTime: Date?
    var lastUpdatedTime: Date?
}

struct RepliesFetchResult {
    var replies = [Reply]()
    var error: RepliesServiceError?
    var cursor: String?
}
