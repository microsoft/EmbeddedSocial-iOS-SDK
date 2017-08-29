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
}

class CommentsService: BaseService, CommentServiceProtocol {
    
    // MARK: Public
    private var imagesService: ImagesServiceType!
    
    init(imagesService: ImagesServiceType) {
        super.init()
        self.imagesService = imagesService
    }
    
    func comment(commentHandle: String, cachedResult: @escaping CommentHandler, success: @escaping CommentHandler, failure: @escaping Failure) {
        
        let request = CommentsAPI.commentsGetCommentWithRequestBuilder(commentHandle: commentHandle, authorization: authorization)
        let requesURLString = request.URLString
        
        let cacheRequestForOutgoing = CacheFetchRequest(resultType: PostTopicRequest.self, predicate: PredicateBuilder().predicate(handle: commentHandle))
        let outgoingFetchResult = cache.fetchOutgoing(with: cacheRequestForOutgoing)
        if !outgoingFetchResult.isEmpty {
            let comment = Comment()
            comment.text = outgoingFetchResult.first?.text
            comment.commentHandle = (outgoingFetchResult.first?.handle)!
            comment.userHandle = SocialPlus.shared.me?.uid
            comment.firstName = SocialPlus.shared.me?.firstName
            comment.firstName = SocialPlus.shared.me?.lastName
            print("COMMENT HANDLE: \(comment.commentHandle)")
            cachedResult(comment)
        } else {
            let cacheRequestForIncoming = CacheFetchRequest(resultType: CommentView.self, predicate: PredicateBuilder().predicate(typeID: requesURLString))
            cachedResult(convert(data: cache.fetchIncoming(with: cacheRequestForIncoming)).first!)
        }
        
        
        request.execute { (result, error) in
            if error != nil {
                failure(error!)
            } else {
//                self.cache.cacheIncoming(result?.body, for: requesURLString)
                success(self.convert(data: [(result?.body)!]).first!)
            }
        }
    }
    
    func fetchComments(topicHandle: String, cursor: String? = nil, limit: Int32? = nil, cachedResult: @escaping CommentFetchResultHandler , resultHandler: @escaping CommentFetchResultHandler) {
        
        let request = CommentsAPI.topicCommentsGetTopicCommentsWithRequestBuilder(topicHandle: topicHandle, authorization: authorization, cursor: cursor, limit: limit)
        let requestURLString = request.URLString
        
        var cacheResult = CommentFetchResult()
        
        let cacheRequest = CacheFetchRequest(resultType: PostTopicRequest.self, predicate: PredicateBuilder().predicate(typeID: topicHandle))
        
        cache.fetchOutgoing(with: cacheRequest).forEach { (cachedNewComments) in
            let comment = Comment()
            comment.text = cachedNewComments.text
            comment.commentHandle = cachedNewComments.handle
            comment.userHandle = SocialPlus.shared.me?.uid
            comment.firstName = SocialPlus.shared.me?.firstName
            comment.firstName = SocialPlus.shared.me?.lastName
            print("COMMENT HANDLE: \(comment.commentHandle)")
            cacheResult.comments.append(comment)
        }
        
        if let cachedComments = self.cache.firstIncoming(ofType: FeedResponseCommentView.self, predicate:  PredicateBuilder().predicate(typeID: requestURLString), sortDescriptors: nil)?.data  {
            cacheResult.comments.append(contentsOf: convert(data: cachedComments))
            cachedResult(cacheResult)
        }
        
        guard let network = NetworkReachabilityManager() else {
            return
        }
        
        if !network.isReachable {
            return
        }
        
        request.execute { (response, error) in
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
            
            self.cache.cacheIncoming(response!.body!, for: requestURLString)
            result.comments = self.convert(data: data)
            result.cursor = response?.body?.cursor
            
            resultHandler(result)
        }
        
    }
    
    func postComment(topicHandle: String, request: PostCommentRequest, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        
        guard let network = NetworkReachabilityManager() else {
            failure(APIError.unknown)
            return
        }
        
        if !network.isReachable {
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
    
    func postComment(topicHandle: String, request: PostCommentRequest, success: @escaping CommentPostResultHandler, failure: @escaping Failure) {
        
        let requestBuilder = CommentsAPI.topicCommentsPostCommentWithRequestBuilder(topicHandle: topicHandle, request: request, authorization: authorization)
        
        guard let network = NetworkReachabilityManager() else {
            return
        }
        
        if !network.isReachable {
            cache.cacheOutgoing(request, for: topicHandle)
            
            let cacheRequest = CacheFetchRequest(resultType: PostTopicRequest.self, predicate: NSPredicate(format: "typeid = %@", topicHandle))
            
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
    public var commentHandle =  NSUUID().uuidString
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
