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
    func postReply(reply: Reply, success: @escaping PostReplyResultHandler, failure: @escaping Failure)
    func reply(replyHandle: String, cachedResult: @escaping ReplyHandler , success: @escaping ReplyHandler, failure: @escaping Failure)
    func delete(reply: Reply, completion: @escaping ((Result<Void>) -> Void))
}

class RepliesService: BaseService, RepliesServiceProtcol {
    
    private var processor: RepliesProcessorType!
    
    init() {
        super.init()
        processor = RepliesProcessor(cache: cache)
    }
    
    func delete(reply: Reply, completion: @escaping ((Result<Void>) -> Void)) {
        let command = RemoveReplyCommand(reply: reply)
        execute(command: command, success: { _ in
            completion(.success())
        }) { (error) in
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                completion(.failure(error))
            }
        }
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
            result.error = RepliesServiceError.failedToFetch(message: L10n.Error.unknown)
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
                result.error = RepliesServiceError.failedToFetch(message: error?.localizedDescription ?? L10n.Error.noItemsReceived)
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
    
    func postReply(reply: Reply, success: @escaping PostReplyResultHandler, failure: @escaping Failure) {
        let replyCommand = CreateReplyCommand(reply: reply)
        
        guard isNetworkReachable else {
            cache.cacheOutgoing(replyCommand)
            success(PostReplyResponse(reply: reply))
            return
        }
        
        let request = PostReplyRequest()
        request.text = reply.text
        
        RepliesAPI.commentRepliesPostReply(
            commentHandle: reply.commentHandle,
            request: request,
            authorization: authorization) { [weak self] response, error in
                guard let strongSelf = self else {
                    return
                }
                if let response = response {
                    success(response)
                } else if strongSelf.errorHandler.canHandle(error) {
                    strongSelf.errorHandler.handle(error)
                } else {
                    failure(APIError(error: error))
                }
        }
    }
    
    
    private func execute(command: RemoveReplyCommand,
                         success: @escaping ((Void) -> Void),
                         failure: @escaping Failure) {
        guard isNetworkReachable else {
            
            let predicate =  PredicateBuilder().createReplyCommand(replyHandle: command.reply.replyHandle)
            let fetchOutgoingRequest = CacheFetchRequest(resultType: OutgoingCommand.self,
                                                         predicate: predicate,
                                                         sortDescriptors: [Cache.createdAtSortDescriptor])
            
            
            if !self.cache.fetchOutgoing(with: fetchOutgoingRequest).isEmpty {
                self.cache.deleteOutgoing(with:predicate)
                success()
                return
            } else {
                cache.cacheOutgoing(command)
                success()
                return
            }
        }
        
        
        let request = RepliesAPI.repliesDeleteReplyWithRequestBuilder(replyHandle: command.reply.replyHandle, authorization: authorization)
        request.execute { (response, error) in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
        
    }
    
    private func convert(data: [ReplyView]) -> [Reply] {
        return data.map(convert(replyView:))
    }
    
    private func convert(replyView: ReplyView) -> Reply {
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
    
    convenience init(replyHandle: String) {
        self.init()
        
        self.replyHandle = replyHandle
    }
    
    convenience init(request: PostReplyRequest) {
        self.init()
        
        replyHandle = UUID().uuidString
        text = request.text
        createdTime = Date()
    }
}

extension Reply: JSONEncodable {
    
    convenience init?(json: [String: Any]) {
        guard let replyHandle = json["replyHandle"] as? String else {
            return nil
        }
        
        self.init()
        
        self.replyHandle = replyHandle
        userHandle = json["userHandle"] as? String
        userFirstName = json["userFirstName"] as? String
        userLastName = json["userLastName"] as? String
        userPhotoUrl = json["userPhotoUrl"] as? String
        text = json["text"] as? String
        totalLikes = json["totalLikes"] as? Int ?? 0
        liked = json["liked"] as? Bool ?? false
        commentHandle = json["commentHandle"] as? String
        topicHandle = json["topicHandle"] as? String
        createdTime = json["createdTime"] as? Date
        lastUpdatedTime = json["lastUpdatedTime"] as? Date
        
        if let rawStatus = json["userStatus"] as? Int, let status = FollowStatus(rawValue: rawStatus) {
            userStatus = status
        } else {
            userStatus = .empty
        }
    }
    
    func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "userHandle": userHandle,
            "userFirstName": userFirstName,
            "userLastName": userLastName,
            "userPhotoUrl": userPhotoUrl,
            "text": text,
            "totalLikes": totalLikes,
            "liked": liked,
            "replyHandle": replyHandle,
            "commentHandle": commentHandle,
            "topicHandle": topicHandle,
            "createdTime": createdTime,
            "lastUpdatedTime": lastUpdatedTime,
            "userStatus": userStatus.rawValue
        ]
        return json.flatMap { $0 }
    }
}

extension Reply: Equatable {
    static func ==(lhs: Reply, rhs: Reply) -> Bool {
        return lhs.replyHandle == rhs.replyHandle
    }
}

struct RepliesFetchResult {
    var replies = [Reply]()
    var error: RepliesServiceError?
    var cursor: String?
}
