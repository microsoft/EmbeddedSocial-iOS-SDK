//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

typealias CommentFetchResultHandler = ((CommentFetchResult) -> Void)
typealias CommentHandler = ((Comment) -> Void)
typealias CommentPostResultHandler = ((Comment) -> Void)

protocol CommentServiceProtocol {
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32?, cachedResult: @escaping CommentFetchResultHandler, resultHandler: @escaping CommentFetchResultHandler)
    func comment(commentHandle: String, cachedResult: @escaping CommentHandler, success: @escaping CommentHandler, failure: @escaping Failure)
    func postComment(comment: Comment, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure)
    func delete(comment: Comment, completion: @escaping ((Result<Void>) -> Void))
}

class CommentsService: BaseService, CommentServiceProtocol {
    
    // MARK: Public
    private let imagesService: ImagesServiceType
    private var processor: CommentsProcessorType!
    private let predicateBuilder = PredicateBuilder()
    private let changesPublisher: Publisher

    init(imagesService: ImagesServiceType, changesPublisher: Publisher = HandleChangesMulticast.shared) {
        self.changesPublisher = changesPublisher
        self.imagesService = imagesService
        super.init()
        processor = CommentsProcessor(cache: cache)
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
                success(Comment(commentView: commentView))
            } else if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
                failure(APIError(error: error))
            } else {
                failure(APIError(error: error))
            }
            
        }
    }
    
    private func cachedComment(with handle: String, requestURL: String) -> Comment? {
        return cachedOutgoingComment(with: handle) ?? cachedIncomingComment(key: requestURL)
    }
    
    private func cachedOutgoingComment(with handle: String) -> Comment? {
        let p = predicateBuilder.createCommentCommand(commentHandle: handle)
        
        let cachedCommand = cache.firstOutgoing(ofType: OutgoingCommand.self,
                                                predicate: p,
                                                sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return (cachedCommand as? CreateCommentCommand)?.comment
    }
    
    private func cachedIncomingComment(key: String) -> Comment? {
        let p = predicateBuilder.predicate(typeID: key)
        let cachedCommentView = cache.firstIncoming(ofType: CommentView.self, predicate: p, sortDescriptors: nil)
        return cachedCommentView != nil ? Comment(commentView: cachedCommentView!) : nil
    }
    
    func fetchComments(topicHandle: String,
                       cursor: String? = nil,
                       limit: Int32? = nil,
                       cachedResult: @escaping CommentFetchResultHandler,
                       resultHandler: @escaping CommentFetchResultHandler) {

        let builder = CommentsAPI.topicCommentsGetTopicCommentsWithRequestBuilder(
            topicHandle: topicHandle,
            authorization: authorization,
            cursor: cursor,
            limit: limit
        )
        
        fetchCachedFeed(topicHandle: topicHandle, url: builder.URLString, cachedResult: cachedResult)
        
        builder.execute { response, error in
            let feed = self.onCommentsFetched(topicHandle: topicHandle,
                                              cursor: cursor,
                                              url: builder.URLString,
                                              response: response?.body,
                                              error: error)
            resultHandler(feed)
        }
    }
    
    private func fetchCachedFeed(topicHandle: String, url: String, cachedResult: @escaping CommentFetchResultHandler) {
        let incomingFeed = cache.firstIncoming(ofType: FeedResponseCommentView.self,
                                               predicate: predicateBuilder.predicate(handle: url),
                                               sortDescriptors: nil)
        
        var feed = CommentFetchResult()
        feed.comments = incomingFeed?.data?.map(Comment.init) ?? []
        processor.proccess(&feed, topicHandle: topicHandle)
        cachedResult(feed)
    }
    
    func onCommentsFetched(topicHandle: String,
                           cursor: String?,
                           url: String,
                           response: FeedResponseCommentView?,
                           error: ErrorResponse?) -> CommentFetchResult {
        
        let typeID = "fetch_commens-\(topicHandle)"
        
        if cursor == nil {
            cache.deleteIncoming(with: predicateBuilder.predicate(typeID: typeID))
        }
        
        var feed = CommentFetchResult()
        
        if let response = response, let data = response.data {
            response.handle = url
            cache.cacheIncoming(response, for: typeID)
            feed.comments = data.map(Comment.init)
            feed.cursor = response.cursor
        } else if errorHandler.canHandle(error) {
            errorHandler.handle(error)
        } else if let error = error {
            feed.error = APIError(error: error)
        }
        
        processor.proccess(&feed, topicHandle: topicHandle)
        
        return feed
    }
    
    func postComment(comment: Comment,
                     photo: Photo?,
                     resultHandler: @escaping CommentPostResultHandler,
                     failure: @escaping Failure) {
        
        let commentCommand = CreateCommentCommand(comment: comment)
        
        guard let image = photo?.image else {
            execute(command: commentCommand, resultHandler: resultHandler, failure: failure)
            return
        }
        
        imagesService.uploadCommentImage(image, commentHandle: comment.commentHandle) { [weak self] result in
            if let handle = result.value {
                commentCommand.setImageHandle(handle)
                self?.execute(command: commentCommand, resultHandler: resultHandler, failure: failure)
            } else if self?.errorHandler.canHandle(result.error) == true {
                self?.errorHandler.handle(result.error)
                failure(result.error ?? APIError.unknown)
            } else {
                failure(result.error ?? APIError.unknown)
            }
        }
    }
    
    func execute(command: CreateCommentCommand,
                 resultHandler: @escaping CommentPostResultHandler,
                 failure: @escaping Failure) {
        
        let isCached = cache.isCached(command)
        if !isCached {
            cache.cacheOutgoing(command)
            resultHandler(command.comment)
        }
        
        CommentsAPI.topicCommentsPostComment(
            topicHandle: command.comment.topicHandle,
            request: PostCommentRequest(comment: command.comment),
            authorization: authorization
        ) { response, error in
            if let newHandle = response?.commentHandle {
                if !isCached {
                    self.onCommentPosted(oldCommand: command, newHandle: newHandle)
                } else {
                    command.comment.commentHandle = newHandle
                    resultHandler(command.comment)
                }
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
                failure(error ?? APIError.unknown)
            } else if let error = error {
                failure(error)
            }
        }
    }
    
    private func onCommentPosted(oldCommand cmd: CreateCommentCommand, newHandle: String) {
        cache.deleteOutgoing(with: predicateBuilder.predicate(for: cmd))
        
        let oldHandle: String = cmd.comment.commentHandle
        cache.cacheOutgoing(UpdateRelatedHandleCommand(oldHandle: oldHandle, newHandle: newHandle))
        
        changesPublisher.notify(CommentUpdateHint(oldHandle: oldHandle, newHandle: newHandle))
    }
    
    func delete(comment: Comment, completion: @escaping (Result<Void>) -> Void) {
        let command = RemoveCommentCommand(comment: comment)
        
        let isCached = cache.isCached(command)
        
        if !isCached {
            completion(.success())
        }
        
        let hasDeletedInverseCommand = cache.deleteInverseCommand(for: command)
        
        guard !hasDeletedInverseCommand else {
            return
        }
        
        cache.cacheOutgoing(command)
        
        CommentsAPI.commentsDeleteComment(
            commentHandle: comment.commentHandle,
            authorization: authorization) { response, error in
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                    completion(.failure(APIError(error: error)))
                } else if error == nil {
                    if !isCached {
                        self.onCommentDeleted(command: command)
                    } else {
                        completion(.success())
                    }
                }
        }
    }
    
    private func onCommentDeleted(command: RemoveCommentCommand) {
        cache.deleteOutgoing(with: predicateBuilder.predicate(for: command))
    }
}

struct CommentFetchResult {
    var comments = [Comment]()
    var error: Error?
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
