//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

typealias RepliesFetchResultHandler = ((RepliesFetchResult) -> Void)
typealias PostReplyResultHandler = ((PostReplyResponse) -> Void)
typealias ReplyHandler = ((Reply) -> Void)

struct RepliesFetchResult {
    var replies = [Reply]()
    var error: Error?
    var cursor: String?
}

protocol RepliesServiceProtcol {
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int,cachedResult:  @escaping RepliesFetchResultHandler,resultHandler: @escaping RepliesFetchResultHandler)
    func postReply(reply: Reply, success: @escaping PostReplyResultHandler, failure: @escaping (APIError) -> (Void))
    func reply(replyHandle: String, cachedResult: @escaping ReplyHandler , success: @escaping ReplyHandler, failure: @escaping Failure)
    func delete(reply: Reply, completion: @escaping ((Result<Void>) -> Void))
}

class RepliesService: BaseService, RepliesServiceProtcol {
    
    private var processor: RepliesProcessorType!
    private let changesPublisher: Publisher

    init(changesPublisher: Publisher = HandleChangesManager.shared) {
        self.changesPublisher = changesPublisher
        super.init()
        processor = RepliesProcessor(cache: cache)
    }
    
    func fetchReplies(commentHandle: String,
                      cursor: String?,
                      limit: Int,
                      cachedResult: @escaping RepliesFetchResultHandler,
                      resultHandler: @escaping RepliesFetchResultHandler) {
        
        let builder = RepliesAPI.commentRepliesGetRepliesWithRequestBuilder(
            commentHandle: commentHandle,
            authorization: authorization,
            cursor: cursor,
            limit: Int32(limit)
        )
        
        fetchCachedFeed(commentHandle: commentHandle, url: builder.URLString, cachedResult: cachedResult)

        builder.execute { response, error in
            let feed = self.onRepliesFetched(commentHandle: commentHandle,
                                             cursor: cursor,
                                             url: builder.URLString,
                                             response: response?.body,
                                             error: error)
            resultHandler(feed)
        }
    }
    
    func onRepliesFetched(commentHandle: String,
                          cursor: String?,
                          url: String,
                          response: FeedResponseReplyView?,
                          error: ErrorResponse?) -> RepliesFetchResult {
        
        let typeID = "fetch_replies-\(commentHandle)"

        if cursor == nil {
            cache.deleteIncoming(with: PredicateBuilder().predicate(typeID: typeID))
        }
        
        var feed = RepliesFetchResult()
        
        if let response = response, let data = response.data {
            response.handle = url
            cache.cacheIncoming(response, for: typeID)
            feed.replies = data.map(Reply.init)
            feed.cursor = response.cursor
        } else if errorHandler.canHandle(error) {
            errorHandler.handle(error)
        } else if let error = error {
            feed.error = APIError(error: error)
        }
        
        processor.proccess(&feed, commentHandle: commentHandle)
        
        return feed
    }
    
    private func fetchCachedFeed(commentHandle: String, url: String, cachedResult: @escaping RepliesFetchResultHandler) {
        let incomingFeed = cache.firstIncoming(ofType: FeedResponseReplyView.self,
                                               predicate: PredicateBuilder().predicate(handle: url),
                                               sortDescriptors: nil)
        
        var feed = RepliesFetchResult()
        feed.replies = incomingFeed?.data?.map(Reply.init) ?? []
        processor.proccess(&feed, commentHandle: commentHandle)
        cachedResult(feed)
    }
    
    func reply(replyHandle: String,
               cachedResult: @escaping ReplyHandler,
               success: @escaping ReplyHandler,
               failure: @escaping Failure) {
        
        let builder = RepliesAPI.repliesGetReplyWithRequestBuilder(replyHandle: replyHandle, authorization: authorization)
        
        if let cachedReply = self.cachedReply(with: replyHandle, requestURL: builder.URLString) {
            cachedResult(cachedReply)
            return
        }
        
        guard isNetworkReachable else {
            failure(APIError.unknown)
            return
        }
        
        builder.execute { [weak self] respose, error in
            guard let strongSelf = self else {
                return
            }
            
            if let replyView = respose?.body {
                strongSelf.cache.cacheIncoming(replyView, for: builder.URLString)
                success(strongSelf.convert(replyView: replyView))
            } else if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
                failure(APIError(error: error))
            } else {
                failure(APIError(error: error))
            }
        }
    }
    
    private func cachedReply(with replyHandle: String, requestURL: String) -> Reply? {
        return cachedOutgoingReply(with: replyHandle) ?? cachedIncomingReply(key: requestURL)
    }
    
    private func cachedOutgoingReply(with replyHandle: String) -> Reply? {
        let p = PredicateBuilder().createReplyCommand(replyHandle: replyHandle)
        
        let cachedCommand = cache.firstOutgoing(ofType: OutgoingCommand.self,
                                                predicate: p,
                                                sortDescriptors: [Cache.createdAtSortDescriptor])
        
        return (cachedCommand as? CreateReplyCommand)?.reply
    }
    
    private func cachedIncomingReply(key: String) -> Reply? {
        let p = PredicateBuilder().predicate(typeID: key)
        let cachedReplyView = cache.firstIncoming(ofType: ReplyView.self, predicate: p, sortDescriptors: nil)
        return cachedReplyView != nil ? convert(replyView: cachedReplyView!) : nil
    }
    
    func postReply(reply: Reply, success: @escaping PostReplyResultHandler, failure: @escaping (APIError) -> (Void)) {
        let command = CreateReplyCommand(reply: reply)
        
        let isCached = cache.isCached(command)
        if !isCached {
            cache.cacheOutgoing(command)
            success(PostReplyResponse(reply: reply))
        }
        
        let request = PostReplyRequest()
        request.text = reply.text
        
        RepliesAPI.commentRepliesPostReply(
            commentHandle: reply.commentHandle,
            request: request,
            authorization: authorization
        ) { response, error in
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
                failure(APIError(error: error))
            } else if let response = response, let newHandle = response.replyHandle {
                if !isCached {
                    self.onReplyPosted(oldCommand: command, response: response)
                } else {
                    command.reply.replyHandle = newHandle
                    success(PostReplyResponse(reply: reply))
                }
            }
        }
    }
    
    private func onReplyPosted(oldCommand cmd: CreateReplyCommand, response: PostReplyResponse) {
        cache.deleteOutgoing(with: PredicateBuilder().predicate(for: cmd))
        
        guard let newHandle = response.replyHandle else { return }
        let oldHandle: String = cmd.reply.replyHandle
        cache.cacheOutgoing(UpdateRelatedHandleCommand(oldHandle: oldHandle, newHandle: newHandle))
        
        changesPublisher.notify(ReplyUpdateHint(oldHandle: oldHandle, newHandle: newHandle))
    }
    
    func delete(reply: Reply, completion: @escaping (Result<Void>) -> Void) {
        let command = RemoveReplyCommand(reply: reply)
        
        let isCached = cache.isCached(command)
        
        if !isCached {
            completion(.success())
        }
        
        let hasDeletedInverseCommand = cache.deleteInverseCommand(for: command)
        
        guard !hasDeletedInverseCommand else {
            return
        }
        
        cache.cacheOutgoing(command)
        
        RepliesAPI.repliesDeleteReply(
            replyHandle: command.reply.replyHandle,
            authorization: authorization) { response, error in
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                    completion(.failure(APIError(error: error)))
                } else if error == nil {
                    if !isCached {
                        self.onReplyDeleted(command: command)
                    } else {
                        completion(.success())
                    }
                }
        }
    }
    
    private func onReplyDeleted(command: RemoveReplyCommand) {
        self.cache.deleteOutgoing(with: PredicateBuilder().predicate(for: command))
    }
    
    private func convert(data: [ReplyView]) -> [Reply] {
        return data.map(Reply.init(replyView:))
    }
    
    private func convert(replyView: ReplyView) -> Reply {
        return Reply(replyView: replyView)
    }
    
}
