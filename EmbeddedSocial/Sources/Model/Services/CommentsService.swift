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
    
    func comment(commentHandle: String,
                 cachedResult: @escaping CommentHandler,
                 success: @escaping CommentHandler,
                 failure: @escaping Failure) {
        
        let builder = CommentsAPI.commentsGetCommentWithRequestBuilder(commentHandle: commentHandle, authorization: authorization)
        
        if let cachedComment = self.cachedComment(with: commentHandle, requestURL: builder.URLString) {
            cachedResult(cachedComment)
            return
        }
        
        guard isNetworkReachable else {
            failure(APIError.unknown)
            return
        }
        
        builder.execute { [weak self] (result, error) in
            guard let strongSelf = self else {
                return
            }
            if let commentView = result?.body {
                strongSelf.cache.cacheIncoming(commentView, for: builder.URLString)
                success(strongSelf.convert(commentView: commentView))
            } else if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
            } else {
                failure(APIError(error: error))
            }
        }
    }
    
    private func cachedComment(with handle: String, requestURL: String) -> Comment? {
        return cachedOutgoingComment(with: handle) ?? cachedIncomingComment(key: requestURL)
    }
    
    private func cachedOutgoingComment(with handle: String) -> Comment? {
        let p = PredicateBuilder.createCommentCommand(commentHandle: handle)
        
        let cachedCommand = cache.firstOutgoing(ofType: OutgoingCommand.self,
                                                predicate: p,
                                                sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return (cachedCommand as? CreateCommentCommand)?.comment
    }
    
    private func cachedIncomingComment(key: String) -> Comment? {
        let p = PredicateBuilder.predicate(typeID: key)
        let cachedCommentView = cache.firstIncoming(ofType: CommentView.self, predicate: p, sortDescriptors: nil)
        return cachedCommentView != nil ? convert(commentView: cachedCommentView!) : nil
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
        
        let builder = CommentsAPI.topicCommentsGetTopicCommentsWithRequestBuilder(
            topicHandle: topicHandle,
            authorization: authorization,
            cursor: cursor, limit: limit
        )
        
        let fetchOutgoingRequest = CacheFetchRequest(resultType: OutgoingCommand.self,
                                                     predicate: PredicateBuilder.allCreateCommentCommands(),
                                                     sortDescriptors: [Cache.createdAtSortDescriptor])
        
        cache.fetchOutgoing(with: fetchOutgoingRequest) { [weak self] commands in
            guard let strongSelf = self else {
                return
            }
            
            let incomingFeed = strongSelf.cache.firstIncoming(ofType: FeedResponseCommentView.self,
                                                              predicate: PredicateBuilder().predicate(handle: builder.URLString),
                                                              sortDescriptors: nil)
            
            let incomingComments = incomingFeed?.data?.map(strongSelf.convert(commentView:)) ?? []
            
            let outgoingComments = commands.flatMap { ($0 as? CreateCommentCommand)?.comment }
            
            let result = CommentFetchResult(comments: outgoingComments + incomingComments, error: nil, cursor: incomingFeed?.cursor)
            
            cachedResult(result)
        }
        
        guard isNetworkReachable else {
            return
        }
        
        builder.execute { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            
            let typeID = "fetch_commens-\(topicHandle)"
            
            if cursor == nil {
                strongSelf.cache.deleteIncoming(with: PredicateBuilder().predicate(typeID: typeID))
            }
            
            var result = CommentFetchResult()
            
            if let body = response?.body, let data = body.data {
                body.handle = builder.URLString
                strongSelf.cache.cacheIncoming(body, for: typeID)
                result.comments = strongSelf.convert(data: data)
                result.cursor = body.cursor
            } else if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
                return
            } else {
                result.error = CommentsServiceError.failedToFetch(message: error?.localizedDescription ?? L10n.Error.noItemsReceived)
            }
            
            resultHandler(result)
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
                commentCommand.comment.mediaHandle = handle
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
            let response = PostCommentResponse(comment: command.comment)
            resultHandler(response)
            return
        }
        
        CommentsAPI.topicCommentsPostComment(
            topicHandle: command.comment.topicHandle,
            request: PostCommentRequest(comment: command.comment),
            authorization: authorization) { (response, error) in
                if let response = response {
                    resultHandler(response)
                } else if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                } else {
                    failure(APIError(error: error))
                }
        }
    }
    
    private func convert(data: [CommentView]) -> [Comment] {
        return data.map(convert(commentView:))
    }
    
    private func convert(commentView: CommentView) -> Comment {
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
        
        return comment
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
