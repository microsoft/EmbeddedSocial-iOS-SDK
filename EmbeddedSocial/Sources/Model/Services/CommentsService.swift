//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

typealias CommentFetchResultHandler = ((CommentFetchResult) -> Void)
typealias CommentHandler = ((Comment) -> Void)
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
    func comment(commentHandle: String, success: @escaping CommentHandler, failure: @escaping Failure)
    func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure)
}

class CommentsService: BaseService, CommentServiceProtocol {
    
    // MARK: Public
    private var imagesService: ImagesServiceType!
    
    init(imagesService: ImagesServiceType) {
        super.init()
        self.imagesService = imagesService
    }
    
    func comment(commentHandle: String, success: @escaping CommentHandler, failure: @escaping Failure) {
        CommentsAPI.commentsGetComment(commentHandle: commentHandle, authorization: authorization) { (commentView, error) in
            if error != nil {
                failure(error!)
            } else {
                success(self.convert(data: [commentView!]).first!)
            }
        }
    }
    
    func fetchComments(topicHandle: String, cursor: String? = nil, limit: Int32? = nil, resultHandler: @escaping CommentFetchResultHandler) {
        CommentsAPI.topicCommentsGetTopicComments(topicHandle: topicHandle, authorization: authorization, cursor: cursor, limit: limit) { (response, error) in
            
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
    
    func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        
        guard let network = NetworkReachabilityManager() else {
            failure(APIError.unknown)
            return
        }
        
        guard network.isReachable else {
            cacheComment(request, with: photo)
            return
        }
        
        guard let image = photo?.image else {
            postComment(topicHandle: topicHandle, request: request, success: resultHandler, failure: failure)
            return
        }
        
        imagesService.uploadContentImage(image) { [unowned self] result in
            if let handle = result.value {
                request.blobHandle = handle
                request.blobType = .image
                self.postComment(topicHandle: topicHandle, request: request, success: resultHandler, failure: failure)
            } else if self.errorHandler.canHandle(result.error) {
                self.errorHandler.handle(result.error)
            } else {
                failure(result.error ?? APIError.unknown)
            }
        }
    }
    
    private func cacheComment(_ comment: PostCommentRequest, with photo: Photo?) {
//        if let photo = photo {
//            cache.cacheOutgoing(photo)
//            comment.blobHandle = photo.uid
//        }
//        cache.cacheOutgoing(comment)
    }
    
    private func postComment(topicHandle: String, request: PostCommentRequest, success: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        CommentsAPI.topicCommentsPostComment(topicHandle: topicHandle, request: request, authorization: authorization) { (response, error) in
            if response != nil {
                success(response!)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
            }
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
            comment.liked = commentView.liked!
            comment.mediaUrl = commentView.blobUrl
            comment.topicHandle = commentView.topicHandle
            comment.totalLikes = commentView.totalLikes!
            comment.totalReplies = commentView.totalReplies!
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

class Comment: Equatable {
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
    public var liked = false
    public var pinned = false
    
    static func ==(left: Comment, right: Comment) -> Bool{
        return left.commentHandle == right.commentHandle
    }
}
