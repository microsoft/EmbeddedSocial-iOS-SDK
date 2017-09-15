//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

typealias RepliesFetchResultHandler = ((RepliesFetchResult) -> Void)
typealias PostReplyResultHandler = ((PostReplyResponse) -> Void)
typealias ReplyHandler = ((Reply) -> Void)

enum RepliesServiceError: Error {
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

protocol RepliesServiceProtcol {
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int,cachedResult:  @escaping RepliesFetchResultHandler,resultHandler: @escaping RepliesFetchResultHandler)
    func postReply(commentHandle: String, request: PostReplyRequest, success: @escaping PostReplyResultHandler, failure: @escaping Failure)
    func reply(replyHandle: String, cachedResult: @escaping ReplyHandler , success: @escaping ReplyHandler, failure: @escaping Failure)
    func delete(replyHandle: String, completion: @escaping ((Result<Void>) -> Void))
}

class RepliesService: BaseService, RepliesServiceProtcol {
    
    func delete(replyHandle: String, completion: @escaping ((Result<Void>) -> Void)) {
        let request = RepliesAPI.repliesDeleteReplyWithRequestBuilder(replyHandle: replyHandle, authorization: authorization)
        request.execute { (response, error) in
            request.execute { (response, error) in
                if let error = error {
                    self.errorHandler.handle(error: error, completion: completion)
                } else {
                    completion(.success())
                }
            }
        }
    }
    
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int,cachedResult:  @escaping RepliesFetchResultHandler,resultHandler: @escaping RepliesFetchResultHandler) {
        
        let request = RepliesAPI.commentRepliesGetRepliesWithRequestBuilder(commentHandle: commentHandle, authorization: authorization, cursor: cursor, limit: Int32(limit))
        let requestURLString = request.URLString
        
        var cacheResult = RepliesFetchResult()
        
        let cacheRequest = CacheFetchRequest(resultType: PostReplyRequest.self, predicate: PredicateBuilder().predicate(typeID: commentHandle))
        
        cache.fetchOutgoing(with: cacheRequest).forEach { (cachedReply) in
            cacheResult.replies.append(createReplyFromRequest(request: cachedReply))
        }
        
        if let fetchResult = self.cache.firstIncoming(ofType: FeedResponseReplyView.self, predicate: PredicateBuilder().predicate(typeID: requestURLString), sortDescriptors: nil) {
            if let cachedReplies = fetchResult.data {
                cacheResult.replies.append(contentsOf: convert(data: cachedReplies))
                cacheResult.cursor = fetchResult.cursor
                cachedResult(cacheResult)
            }
        } else {
            //TODO : Remove this when finish testing
            cachedResult(cacheResult)
        }
        
        if isNetworkReachable {
            request.execute { (response, error) in
                var result = RepliesFetchResult()
                
                guard error == nil else {
                    result.error = RepliesServiceError.failedToFetch(message: error!.localizedDescription)
                    resultHandler(result)
                    return
                }
                
                guard let data = response?.body?.data else {
                    result.error = RepliesServiceError.failedToFetch(message: L10n.Error.noItemsReceived)
                    resultHandler(result)
                    return
                }
                
                if let body = response?.body {
                    self.cache.cacheIncoming(body, for: requestURLString)
                    result.replies = self.convert(data: data)
                    result.cursor = body.cursor
                }
                
                resultHandler(result)
            }
        }
    }
    
    func reply(replyHandle: String, cachedResult: @escaping ReplyHandler , success: @escaping ReplyHandler, failure: @escaping Failure) {
        
        let request = RepliesAPI.repliesGetReplyWithRequestBuilder(replyHandle: replyHandle, authorization: authorization)
        let requestURLString = request.URLString
        
        let cacheRequestForOutgoing = CacheFetchRequest(resultType: PostReplyRequest.self, predicate: PredicateBuilder().predicate(handle: replyHandle))
        let outgoingFetchResult = cache.fetchOutgoing(with: cacheRequestForOutgoing)
        
        if !outgoingFetchResult.isEmpty {
            cachedResult(createReplyFromRequest(request: outgoingFetchResult.first!))
        } else {
            let cacheRequestForIncoming = CacheFetchRequest(resultType: ReplyView.self, predicate: PredicateBuilder().predicate(typeID: requestURLString))
            if let convertedReply = convert(data: cache.fetchIncoming(with: cacheRequestForIncoming)).first {
                cachedResult(convertedReply)
            }
        }
        
        if isNetworkReachable {
            request.execute { (respose, error) in
                if error != nil {
                    failure(error!)
                } else {
                    self.cache.cacheIncoming((respose?.body)!, for: requestURLString)
                    if let convertedReply = self.convert(data: [(respose?.body)!]).first {
                        success(convertedReply)
                    }
                    
                }
            }
        }

    }
    
    func postReply(commentHandle: String, request: PostReplyRequest, success: @escaping PostReplyResultHandler, failure: @escaping Failure) {
        
        let requestBuilder = RepliesAPI.commentRepliesPostReplyWithRequestBuilder(commentHandle: commentHandle, request: request, authorization: authorization)
        
        guard let network = NetworkReachabilityManager() else {
            return
        }
        
        if !network.isReachable {
            cache.cacheOutgoing(request, for: commentHandle)
            
            let cacheRequest = CacheFetchRequest(resultType: PostReplyRequest.self, predicate: PredicateBuilder().predicate(typeID: commentHandle))
            
            let replyHandle = cache.fetchOutgoing(with: cacheRequest).last?.handle
            
            let result = PostReplyResponse()
            result.replyHandle = replyHandle
            
            success(result)
            
            return
        }
        
        requestBuilder.execute { (response, error) in
            if response != nil {
                success((response?.body)!)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
            }
        }
    
    }
    
    private func convert(data: [ReplyView]) -> [Reply] {
        var replies = [Reply]()
        for replyView in data {
            let reply = Reply()
            reply.commentHandle = replyView.commentHandle
            reply.text = replyView.text
            reply.liked = replyView.liked ?? false
            reply.replyHandle = replyView.replyHandle!
            reply.topicHandle = replyView.topicHandle
            reply.createdTime = replyView.createdTime
            reply.lastUpdatedTime = replyView.lastUpdatedTime
            reply.userFirstName = replyView.user?.firstName
            reply.userLastName = replyView.user?.lastName
            reply.userPhotoUrl = replyView.user?.photoUrl
            reply.userHandle = replyView.user?.userHandle
            reply.totalLikes = Int(replyView.totalLikes!)
            reply.userStatus = FollowStatus(status: replyView.user?.followerStatus)
            
            let request = CacheFetchRequest(resultType: OutgoingCommand.self,
                                            predicate: PredicateBuilder.allReplyCommandsPredicate(for: replyView.replyHandle!),
                                            sortDescriptors: [Cache.createdAtSortDescriptor])
            let commands = cache.fetchOutgoing(with: request) as? [ReplyCommand] ?? []
            
            /*let cacheRequestForReplies = CacheFetchRequest(resultType: FeedActionRequest.self, predicate: PredicateBuilder().predicate(handle: replyView.replyHandle!))
            let cacheResultForReplies = cache.fetchOutgoing(with: cacheRequestForReplies)
            
            if let firstCachedLikeAction = cacheResultForReplies.first {
                switch firstCachedLikeAction.actionMethod {
                case .post:
                    reply.totalLikes += 1
                    reply.liked = true
                case .delete:
                    reply.totalLikes = reply.totalLikes > 0 ? reply.totalLikes - 1 : 0
                    reply.liked = false
                }
            }*/
            
            replies.append(reply)
        }
        return replies
    }
    
    private func createReplyFromRequest(request: PostReplyRequest) -> Reply {
        let reply = Reply()
        reply.text = request.text
        reply.replyHandle = request.handle
        reply.commentHandle = request.relatedHandle
        reply.userHandle = SocialPlus.shared.me?.uid
        reply.userPhotoUrl = SocialPlus.shared.me?.photo?.url
        reply.userFirstName = SocialPlus.shared.me?.firstName
        reply.userLastName = SocialPlus.shared.me?.lastName
        return reply
    }
}

class Reply {
    var userHandle: String?
    var userFirstName: String?
    var userLastName: String?
    var userPhotoUrl: String?
    
    var text: String?
    var totalLikes: Int = 0
    var liked = false
    
    var replyHandle: String!
    var commentHandle: String!
    var topicHandle: String?
    var createdTime: Date?
    var lastUpdatedTime: Date?
    var userStatus: FollowStatus = .empty
    
    var user: User? {
        guard let userHandle = userHandle else { return nil }
        return User(uid: userHandle, firstName: userFirstName, lastName: userLastName, photo: Photo(url: userPhotoUrl))
    }
}

struct RepliesFetchResult {
    var replies = [Reply]()
    var error: RepliesServiceError?
    var cursor: String?
}
