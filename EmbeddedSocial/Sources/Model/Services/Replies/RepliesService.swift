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
        
        var result = RepliesFetchResult()
        
        let fetchOutgoingRequest = CacheFetchRequest(resultType: OutgoingCommand.self,
                                                     predicate: PredicateBuilder().allCreateReplyCommands(),
                                                     sortDescriptors: [Cache.createdAtSortDescriptor])
        
        let commands = cache.fetchOutgoing(with: fetchOutgoingRequest)
        let outgoingReplies = commands.flatMap { ($0 as? CreateReplyCommand)?.reply }
        let incomingFeed = self.cache.firstIncoming(ofType: FeedResponseReplyView.self,
                                                    predicate: PredicateBuilder().predicate(handle: builder.URLString),
                                                    sortDescriptors: nil)
        
        let incomingReplies = incomingFeed?.data?.map(self.convert(replyView:)) ?? []
        
        
        result.replies = outgoingReplies + incomingReplies
        result.cursor = incomingFeed?.cursor
        
        processor.proccess(&result)
        cachedResult(result)
        
        
        guard isNetworkReachable else {
            result.error = APIError.unknown
            resultHandler(result)
            return
        }
        
        builder.execute { [weak self] (response, error) in
            guard let strongSelf = self else {
                return
            }
            
            let typeID = "fetch_replies-\(commentHandle)"
            
            if cursor == nil {
                strongSelf.cache.deleteIncoming(with: PredicateBuilder().predicate(typeID: typeID))
            }

            if let body = response?.body, let data = body.data {
                body.handle = builder.URLString
                strongSelf.cache.cacheIncoming(body, for: typeID)
                result.replies = strongSelf.convert(data: data)
                result.cursor = body.cursor
            } else if strongSelf.errorHandler.canHandle(error) {
                strongSelf.errorHandler.handle(error)
                return
            } else {
                guard let unwrappedError = error else {
                    resultHandler(result)
                    return
                }
                
                if unwrappedError.statusCode >= Constants.HTTPStatusCodes.InternalServerError.rawValue {
                    resultHandler(result)
                } else {
                    result.error = APIError(error: error)
                }
            }
            
            resultHandler(result)
        }
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
        let replyCommand = CreateReplyCommand(reply: reply)
        cache.cacheOutgoing(replyCommand)
        success(PostReplyResponse(reply: reply))
        
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
            } else if let response = response {
                self.onReplyPosted(oldCommand: replyCommand, response: response)
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
    
    func delete(reply: Reply, completion: @escaping ((Result<Void>) -> Void)) {
        let command = RemoveReplyCommand(reply: reply)
        
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
                    let p = PredicateBuilder().predicate(for: command)
                    self.cache.deleteOutgoing(with: p)
                    completion(.success())
                }
        }
    }
    
    private func convert(data: [ReplyView]) -> [Reply] {
        return data.map(Reply.init(replyView:))
    }
    
    private func convert(replyView: ReplyView) -> Reply {
        return Reply(replyView: replyView)
    }
    
}
