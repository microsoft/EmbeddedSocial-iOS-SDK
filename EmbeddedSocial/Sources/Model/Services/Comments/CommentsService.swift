//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

typealias CommentFetchResultHandler = ((CommentFetchResult) -> Void)
typealias CommentHandler = ((Comment) -> Void)
typealias CommentPostResultHandler = ((Comment) -> Void)

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
    func postComment(comment: Comment, photo: Photo?, resultHandler: @escaping CommentPostResultHandler, failure: @escaping Failure)
    func delete(comment: Comment, completion: @escaping ((Result<Void>) -> Void))
}

class CommentsService: BaseService, CommentServiceProtocol {
    
    // MARK: Public
    private var imagesService: ImagesServiceType!
    private var processor: CommentsProcessorType!
    private let predicateBuilder = PredicateBuilder()
    
    init(imagesService: ImagesServiceType) {
        super.init()
        self.imagesService = imagesService
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
                success(strongSelf.convert(commentView: commentView))
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
        return cachedCommentView != nil ? convert(commentView: cachedCommentView!) : nil
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
        
        var result = CommentFetchResult()
        
        let fetchOutgoingRequest = CacheFetchRequest(resultType: OutgoingCommand.self,
                                                     predicate: predicateBuilder.allCreateCommentCommands(for: topicHandle),
                                                     sortDescriptors: [Cache.createdAtSortDescriptor])
        
        let commands = cache.fetchOutgoing(with: fetchOutgoingRequest)
        let incomingFeed = self.cache.firstIncoming(ofType: FeedResponseCommentView.self,
                                                          predicate: predicateBuilder.predicate(handle: builder.URLString),
                                                          sortDescriptors: nil)
        
        let incomingComments = incomingFeed?.data?.map(self.convert(commentView:)) ?? []
        
        let outgoingComments = commands.flatMap { ($0 as? CreateCommentCommand)?.comment }
        
        result.comments = outgoingComments + incomingComments
        result.cursor = incomingFeed?.cursor
        
        processor.proccess(&result)
        cachedResult(result)
        
        guard isNetworkReachable else {
            result.error = CommentsServiceError.failedToFetch(message: L10n.Error.unknown)
            resultHandler(result)
            return
        }
        
        builder.execute { [weak self, predicateBuilder] (response, error) in
            
            result = CommentFetchResult()
            
            guard let strongSelf = self else {
                return
            }
            
            let typeID = "fetch_commens-\(topicHandle)"
            
            if cursor == nil {
                strongSelf.cache.deleteIncoming(with: predicateBuilder.predicate(typeID: typeID))
            }
           
            if let body = response?.body, let data = body.data {
                body.handle = builder.URLString
                strongSelf.cache.cacheIncoming(body, for: typeID)
                result.comments = strongSelf.convert(data: data)
                result.cursor = body.cursor
            } else if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
            } else  if let error = error {
                result.error = CommentsServiceError.failedToFetch(message: error.localizedDescription)
            }
            
            resultHandler(result)
        }
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
    
    private func execute(command: CreateCommentCommand,
                         resultHandler: @escaping CommentPostResultHandler,
                         failure: @escaping Failure) {
        
        cache.cacheOutgoing(command)
        resultHandler(command.comment)
        
        CommentsAPI.topicCommentsPostComment(
            topicHandle: command.comment.topicHandle,
            request: PostCommentRequest(comment: command.comment),
            authorization: authorization) { (response, error) in
                if response != nil {
                    self.cache.deleteOutgoing(with: self.predicateBuilder.predicate(for: command))
                } else if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                }
        }
    }
    
    func delete(comment: Comment, completion: @escaping (Result<Void>) -> Void) {
        completion(.success())

        let command = RemoveCommentCommand(comment: comment)
        let hasDeletedInverseCommand = deleteInverseCommand(command)
        
        guard !hasDeletedInverseCommand else {
            return
        }
        
//        let update
        cache.cacheOutgoing(command)
        
        CommentsAPI.commentsDeleteComment(
            commentHandle: comment.commentHandle,
            authorization: authorization) { response, error in
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                    completion(.failure(APIError(error: error)))
                } else if error == nil {
                    let p = self.predicateBuilder.predicate(for: command)
                    self.cache.deleteOutgoing(with: p)
                }
        }
    }
    
    private func deleteInverseCommand(_ cmd: RemoveCommentCommand) -> Bool {
        guard let inverseCmd = cmd.inverseCommand else {
            return false
        }
        let p = predicateBuilder.predicate(for: inverseCmd)
        let inverseCmdFound = cache.firstOutgoing(ofType: OutgoingCommand.self, predicate: p, sortDescriptors: nil) != nil
        if inverseCmdFound {
            cache.deleteOutgoing(with: p)
        }
        return inverseCmdFound
    }
    
    private func convert(data: [CommentView]) -> [Comment] {
        return data.map(convert(commentView:))
    }
    
    private func convert(commentView: CommentView) -> Comment {
        let comment = Comment()
        comment.commentHandle = commentView.commentHandle!
        comment.user = User(compactView: commentView.user!)
        comment.createdTime = commentView.createdTime
        comment.text = commentView.text
        comment.mediaUrl = commentView.blobUrl
        comment.mediaHandle = commentView.blobHandle
        comment.topicHandle = commentView.topicHandle
        comment.totalLikes = commentView.totalLikes ?? 0
        comment.liked = commentView.liked ?? false
        comment.userStatus = FollowStatus(status: commentView.user?.followerStatus)
        comment.totalReplies = commentView.totalReplies ?? 0 
        
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
