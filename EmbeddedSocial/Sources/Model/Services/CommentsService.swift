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
    
    func fetchComments(topicHandle: String,
                       cursor: String? = nil,
                       limit: Int32? = nil,
                       cachedResult: @escaping CommentFetchResultHandler,
                       resultHandler: @escaping CommentFetchResultHandler) {
        
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
    
    func postComment(topicHandle: String,
                     request: PostCommentRequest,
                     photo: Photo?,
                     resultHandler: @escaping CommentPostResultHandler,
                     failure: @escaping Failure) {
        
        let comment = Comment(request: request, photo: photo, topicHandle: topicHandle)
        let commentCommand = CreateCommentCommand(comment: comment)
        
        guard let image = photo?.image else {
            execute(command: commentCommand, resultHandler: resultHandler, failure: failure)
            return
        }
        
        imagesService.uploadCommentImage(image, commentHandle: comment.commentHandle) { [weak self] result in
            if let handle = result.value {
                commentCommand.comment.photoHandle = handle
                self?.execute(command: commentCommand, resultHandler: resultHandler, failure: failure)
            } else if self?.errorHandler.canHandle(result.error) == true {
                self?.errorHandler.handle(result.error)
            } else {
                failure(result.error ?? APIError.unknown)
            }
        }
    }
    
    private func execute(command: CreateCommentCommand,
                         resultHandler: @escaping CommentPostResultHandler,
                         failure: @escaping Failure) {
        
        guard isNetworkReachable else {
            cache.cacheOutgoing(command)
            return
        }
        
        let request = PostCommentRequest()
        request.text = command.comment.text
        
        if let photoHandle = command.comment.photoHandle {
            request.blobHandle = photoHandle
            request.blobType = .image
        }
        
        CommentsAPI.topicCommentsPostComment(
            topicHandle: command.comment.topicHandle,
            request: request,
            authorization: authorization) { (response, error) in
                if let response = response {
                    resultHandler(response)
                } else if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                } else {
                    failure(error ?? APIError.unknown)
                }
        }
    }
    
    private func cachePhoto(photo: Photo, for topicHandle: String) {
        cache.cacheOutgoing(photo, for: topicHandle)
    }
    
    private func postComment(topicHandle: String,
                             request: PostCommentRequest,
                             success: @escaping CommentPostResultHandler,
                             failure: @escaping Failure) {
        
        let requestBuilder = CommentsAPI.topicCommentsPostCommentWithRequestBuilder(
            topicHandle: topicHandle,
            request: request,
            authorization: authorization
        )
        
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
            var comment = Comment()
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
            
            let cacheRequestForComment = CacheFetchRequest(
                resultType: PostReplyRequest.self,
                predicate: PredicateBuilder().predicate(typeID: commentView.commentHandle!))
            
            let cachedRepliesCount = cache.fetchOutgoing(with: cacheRequestForComment).count
            comment.totalReplies = (commentView.totalReplies ?? 0) + Int64(cachedRepliesCount)
            
            let request = CacheFetchRequest(
                resultType: OutgoingCommand.self,
                predicate: PredicateBuilder.allCommentCommandsPredicate(for: commentView.commentHandle!),
                sortDescriptors: [Cache.createdAtSortDescriptor]
            )
            
            let commands = cache.fetchOutgoing(with: request) as? [CommentCommand] ?? []
            
            for command in commands {
                command.apply(to: &comment)
            }

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
