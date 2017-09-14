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
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32?, cachedResult: @escaping CommentFetchResultHandler, resultHandler: @escaping CommentFetchResultHandler)
    func comment(commentHandle: String, cachedResult: @escaping CommentHandler, success: @escaping CommentHandler, failure: @escaping Failure)
    func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure)
    func deleteComment(commentHandle: String, completion: @escaping ((Result<Void>) -> Void))
}

class CommentsService: BaseService, CommentServiceProtocol {
    
    // MARK: Public
    private var imagesService: ImagesServiceType!
    
    init(imagesService: ImagesServiceType) {
        super.init()
        self.imagesService = imagesService
    }
    
    func deleteComment(commentHandle: String, completion: @escaping ((Result<Void>) -> Void)) {
        let request = CommentsAPI.commentsDeleteCommentWithRequestBuilder(commentHandle: commentHandle, authorization: authorization)
        request.execute { (response, error) in
            if let error = error {
                self.errorHandler.handle(error: error, completion: completion)
            } else {
                completion(.success())
            }
        }
    }
    
    func comment(commentHandle: String, cachedResult: @escaping CommentHandler, success: @escaping CommentHandler, failure: @escaping Failure) {
        
        let request = CommentsAPI.commentsGetCommentWithRequestBuilder(commentHandle: commentHandle, authorization: authorization)
        let requesURLString = request.URLString
        
        let cacheRequestForOutgoing = CacheFetchRequest(resultType: PostCommentRequest.self, predicate: PredicateBuilder().predicate(handle: commentHandle))
        let outgoingFetchResult = cache.fetchOutgoing(with: cacheRequestForOutgoing)
        
        if !outgoingFetchResult.isEmpty {
            cachedResult(createCommentFromRequest(request: outgoingFetchResult.first!))
        } else {
            let cacheRequestForIncoming = CacheFetchRequest(resultType: CommentView.self, predicate: PredicateBuilder().predicate(typeID: requesURLString))
            if let convertedComment = convert(data: cache.fetchIncoming(with: cacheRequestForIncoming)).first {
                cachedResult(convertedComment)
            }
        }
        
        if isNetworkReachable {
            request.execute { (result, error) in
                if let body = result?.body {
                    self.cache.cacheIncoming(body, for: requesURLString)
                    success(self.convert(data: [body]).first!)
                } else {
                    failure(error ?? APIError.unknown)
                }
            }
        }

    }
    
    private func createCommentFromRequest(request: PostCommentRequest) -> Comment {
        let comment = Comment()
        comment.text = request.text
        comment.commentHandle = request.handle
        comment.topicHandle = request.relatedHandle
        comment.userHandle = SocialPlus.shared.me?.uid
        comment.photoUrl = SocialPlus.shared.me?.photo?.url
        comment.firstName = SocialPlus.shared.me?.firstName
        comment.lastName = SocialPlus.shared.me?.lastName
        return comment
    }
    
    func fetchComments(topicHandle: String, cursor: String? = nil, limit: Int32? = nil, cachedResult: @escaping CommentFetchResultHandler , resultHandler: @escaping CommentFetchResultHandler) {
        
        let request = CommentsAPI.topicCommentsGetTopicCommentsWithRequestBuilder(topicHandle: topicHandle, authorization: authorization, cursor: cursor, limit: limit)
        let requestURLString = request.URLString
        
        var cacheResult = CommentFetchResult()
        
        let cacheRequest = CacheFetchRequest(resultType: PostCommentRequest.self, predicate: PredicateBuilder().predicate(typeID: topicHandle))
        
        cache.fetchOutgoing(with: cacheRequest).forEach { (cachedNewComments) in
            cacheResult.comments.append(createCommentFromRequest(request: cachedNewComments))
        }
        
        if let fetchResult = self.cache.firstIncoming(ofType: FeedResponseCommentView.self, predicate:  PredicateBuilder().predicate(typeID: requestURLString), sortDescriptors: nil)  {
            if let cachedComments = fetchResult.data {
                cacheResult.comments.append(contentsOf: convert(data: cachedComments))
                cacheResult.cursor = fetchResult.cursor
                cachedResult(cacheResult)
            }
        }
        
        if isNetworkReachable {
            request.execute { (response, error) in
                
                if cursor == nil {
                    //TODO: remove cached comments for topicHandle
                }
                
                var result = CommentFetchResult()
                
                guard error == nil else {
                    result.error = CommentsServiceError.failedToFetch(message: error!.localizedDescription)
                    resultHandler(result)
                    return
                }
                
                guard let data = response?.body?.data else {
                    result.error = CommentsServiceError.failedToFetch(message: L10n.Error.noItemsReceived)
                    resultHandler(result)
                    return
                }
                
                if let body = response?.body {
                    self.cache.cacheIncoming(body, for: requestURLString)
                    result.comments = self.convert(data: data)
                    result.cursor = body.cursor
                }
                
                resultHandler(result)
            }
        }

        
    }
    
    func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        
        if !isNetworkReachable {
            if let unwrapptedPhoto = photo {
                cachePhoto(photo: unwrapptedPhoto, for: topicHandle)
            }
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
    
    private func cachePhoto(photo: Photo, for topicHandle: String) {
        cache.cacheOutgoing(photo, for: topicHandle)
    }
    
    private func postComment(topicHandle: String, request: PostCommentRequest, success: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        
        let requestBuilder = CommentsAPI.topicCommentsPostCommentWithRequestBuilder(topicHandle: topicHandle, request: request, authorization: authorization)
        
        if !isNetworkReachable {
            cache.cacheOutgoing(request, for: topicHandle)
            
            let cacheRequest = CacheFetchRequest(resultType: PostCommentRequest.self, predicate: PredicateBuilder().predicate(typeID: topicHandle))
            
            let commentHandle = self.cache.fetchOutgoing(with: cacheRequest).last?.handle
            
            let result = PostCommentResponse()
            result.commentHandle = commentHandle
            
            success(result)
            
            return
        }
        
        requestBuilder.execute { (response, error) in
            if response != nil {
                success(response!.body!)
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
            comment.commentHandle = commentView.commentHandle!
            comment.firstName = commentView.user?.firstName
            comment.lastName = commentView.user?.lastName
            comment.photoUrl = commentView.user?.photoUrl
            comment.userHandle = commentView.user?.userHandle
            comment.createdTime = commentView.createdTime
            comment.text = commentView.text
            comment.mediaUrl = commentView.blobUrl
            comment.topicHandle = commentView.topicHandle
            comment.totalLikes = commentView.totalLikes ?? 0
            comment.liked = commentView.liked ?? false
            comment.userStatus = FollowStatus(status: commentView.user?.followerStatus)

            let cacheRequestForLikes = CacheFetchRequest(resultType: FeedActionRequest.self, predicate: PredicateBuilder().predicate(handle: commentView.commentHandle!))
            let cacheResultForLikes = cache.fetchOutgoing(with: cacheRequestForLikes)

            if let firstCachedLikeAction = cacheResultForLikes.first {
                switch firstCachedLikeAction.actionMethod {
                case .post:
                    comment.totalLikes += 1
                    comment.liked = true
                case .delete:
                    comment.totalLikes = comment.totalLikes > 0 ? comment.totalLikes - 1 : 0
                    comment.liked = false
                }
            }
            
            let cacheRequestForComment = CacheFetchRequest(resultType: PostReplyRequest.self, predicate: PredicateBuilder().predicate(typeID: commentView.commentHandle!))
            comment.totalReplies = (commentView.totalReplies ?? 0) + Int64(cache.fetchOutgoing(with: cacheRequestForComment).count)
            
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

struct CommentViewModel {
    
    typealias ActionHandler = (CommentCellAction, Int) -> Void
    
    var comment: Comment?
    var userName: String = ""
    var title: String = ""
    var text: String = ""
    var isLiked: Bool = false
    var totalLikes: String = ""
    var totalReplies: String = ""
    var timeCreated: String = ""
    var userImageUrl: String? = nil
    var commentImageUrl: String? = nil
    var commentHandle: String = ""
    
    var tag: Int = 0
    var cellType: String = CommentCell.reuseID
    var onAction: ActionHandler?
}

class Comment: Equatable {
    
    public var commentHandle: String!
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
    public var userStatus: FollowStatus = .empty
    
    var user: User? {
        guard let userHandle = userHandle else { return nil }
        return User(uid: userHandle, firstName: firstName, lastName: lastName, photo: Photo(url: photoUrl))
    }
    
    static func ==(left: Comment, right: Comment) -> Bool{
        return left.commentHandle == right.commentHandle
    }
}
