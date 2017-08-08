//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

typealias CommentFetchResultHandler = ((CommentFetchResult) -> Void)
typealias CommentPostResultHandler = ((PostCommentResponse) -> Void)

enum CommentsServiceError: Error {
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

protocol CommentServiceProtocol {
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32?, resultHandler: @escaping CommentFetchResultHandler)
    func postComment(topicHandle: String, comment: PostCommentRequest, resultHandler: @escaping CommentPostResultHandler)
}

class CommentsService: CommentServiceProtocol {
    func fetchComments(topicHandle: String, cursor: String? = nil, limit: Int32? = nil, resultHandler: @escaping CommentFetchResultHandler) {
        CommentsAPI.topicCommentsGetTopicComments(topicHandle: topicHandle, cursor: cursor, limit: limit) { (response, error) in
            
            var result = CommentFetchResult()
            
            guard error == nil else {
                result.error = CommentsServiceError.failedToFetch(message: error!.localizedDescription)
                resultHandler(result)
                return
            }
            
            guard let data = response?.data else {
                result.error = CommentsServiceError.failedToFetch(message: "No Items Received")
                resultHandler(result)
                return
            }
            
            result.comments = self.convert(data: data)
            result.cursor = response?.cursor
            
            resultHandler(result)
        }
    }
    
    func postComment(topicHandle: String, comment: PostCommentRequest, resultHandler: @escaping CommentPostResultHandler) {
        CommentsAPI.topicCommentsPostComment(topicHandle: topicHandle, request: comment) { (resposne, error) in
            resultHandler(resposne!)
        }
    }
    
    private func convert(data: [CommentView]) -> [Comment] {
        var comments = [Comment]()
        for commentView in data {
            let comment = Comment()
            comment.commentHandle = commentView.commentHandle
            comment.firstName = commentView.user?.firstName
            comment.lastName = commentView.user?.lastName
            comment.photoUrl = commentView.user?.photoUrl
            comment.userHandle = commentView.user?.userHandle
            comment.createdTime = commentView.createdTime
            comment.text = commentView.text
            comment.liked = commentView.liked
            comment.mediaUrl = commentView.blobUrl
            comment.topicHandle = commentView.topicHandle
            comment.totalLikes = commentView.totalLikes ?? 0
            comment.totalReplies = commentView.totalLikes ?? 0
            comments.append(comment)
        }
        return comments
        
    }
}

struct CommentFetchResult {
    var comments = [Comment]()
    var error: CommentsServiceError?
    var cursor: String?
}

class Comment {
    public var commentHandle: String?
    public var topicHandle: String!
    public var createdTime: Date?
    
    public var userHandle: String?
    public var firstName: String?
    public var lastName: String?
    public var photoHandle: String?
    public var photoUrl: String?
    
    public var text: String?
    public var mediaUrl: String?
    public var totalLikes: Int64 = 0
    public var totalReplies: Int64 = 0
    public var liked: Bool!
    public var pinned: Bool!
}
