//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias RepliesFetchResultHandler = ((RepliesFetchResult) -> Void)

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
    func fetchComments(commentHandle: String, cursor: String, limit: Int, resultHandler: @escaping RepliesFetchResultHandler)
}

class RepliesService: BaseService, RepliesServiceProtcol {
    func fetchComments(commentHandle: String, cursor: String, limit: Int, resultHandler: @escaping RepliesFetchResultHandler) {
        RepliesAPI.commentRepliesGetReplies(commentHandle: commentHandle, authorization: authorization, cursor: cursor, limit: Int32(limit)) { (response, error) in
            var result = RepliesFetchResult()
            
            guard error == nil else {
                result.error = RepliesServiceError.failedToFetch(message: error!.localizedDescription)
                resultHandler(result)
                return
            }
            
            guard let data = response?.data else {
                result.error = RepliesServiceError.failedToFetch(message: "No Items Received")
                resultHandler(result)
                return
            }
            
            result.replies = self.convert(data: data)
            result.cursor = response?.cursor
            
            resultHandler(result)
        }
    }
    
    private func convert(data: [ReplyView]) -> [Reply] {
        let replies = [Reply]()
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
        }
        return replies
    }
}

class Reply {
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
