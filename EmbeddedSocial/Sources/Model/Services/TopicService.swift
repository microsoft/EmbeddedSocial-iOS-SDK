//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//
import Foundation
import Alamofire

typealias TopicPosted = (PostTopicRequest) -> Void
typealias Failure = (Error) -> Void

enum FeedServiceError: Error {
    case failedToFetch(message: String)
    case failedToLike(message: String)
    case failedToUnLike(message: String)
    case failedToPin(message: String)
    case failedToUnPin(message: String)
    
    var message: String {
        switch self {
        case .failedToFetch(let message),
             .failedToPin(let message),
             .failedToUnPin(let message),
             .failedToLike(let message),
             .failedToUnLike(let message):
            return message
        }
    }
}

typealias FetchResultHandler = ((PostFetchResult) -> Void)

protocol FeedQueryType {
    var cursor: String? { get set }
    var limit: Int32? { get set }
}

extension FeedQueryType {
    mutating func setCursor(_ cursor: Int32?) {
        self.cursor = cursor == nil ? nil : String(cursor!)
    }
    
    func cursorInt() -> Int32? {
        return (cursor == nil) ? nil : Int32(cursor!)
    }
}

struct FeedQuery: FeedQueryType {
    var cursor: String?
    var limit: Int32?
}

struct PopularFeedQuery: FeedQueryType {
    var cursor: String?
    var limit: Int32?
    var timeRange: TopicsAPI.TimeRange_topicsGetPopularTopics!
}

struct UserFeedQuery: FeedQueryType {
    var cursor: String?
    var limit: Int32?
    var user: UserHandle!
}

protocol PostServiceProtocol {
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler)
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler)
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler)
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler)
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler)
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler)
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler)
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void))
    
}

protocol PostServiceDelegate: class {
    
    func didFetchHome(query: FeedQuery, result: PostFetchResult)
}

class TopicService: BaseService, PostServiceProtocol {
    
    private var imagesService: ImagesServiceType!
    
    init(imagesService: ImagesServiceType) {
        super.init()
        self.imagesService = imagesService
    }
    
    init() {
        super.init()
    }
    
    func postTopic(topic: PostTopicRequest, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure) {
        guard let network = NetworkReachabilityManager() else {
            failure(APIError.unknown)
            return
        }
        
        guard network.isReachable else {
            cacheTopic(topic, with: photo)
            return
        }
        
        guard let image = photo?.image else {
            postTopic(request: topic, success: success, failure: failure)
            return
        }
        
        imagesService.uploadContentImage(image) { [unowned self] result in
            if let handle = result.value {
                topic.blobHandle = handle
                topic.blobType = .image
                self.postTopic(request: topic, success: success, failure: failure)
            } else if self.errorHandler.canHandle(result.error) {
                self.errorHandler.handle(result.error)
            } else {
                failure(result.error ?? APIError.unknown)
            }
        }
    }
    
    func updateTopic(topicHandle: String, request: PutTopicRequest, success: @escaping () ->(), failure: @escaping (Error) ->() ) {
        TopicsAPI.topicsPutTopic(topicHandle: topicHandle, request: request, authorization: authorization) { (object, error) in
            if error != nil {
                failure(error!)
            } else {
                success()
            }
        }
    }
    
    private func cacheTopic(_ topic: PostTopicRequest, with photo: Photo?) {
        if let photo = photo {
            cache.cacheOutgoing(photo)
            topic.blobHandle = photo.uid
        }
        cache.cacheOutgoing(topic)
    }
    
    private func postTopic(request: PostTopicRequest, success: @escaping TopicPosted, failure: @escaping Failure) {
        TopicsAPI.topicsPostTopic(request: request, authorization: authorization) { response, error in
            if response != nil {
                success(request)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
            }
        }
    }
    
    // MARK: GET
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let request = PinsAPI.myPinsGetPinsWithRequestBuilder(authorization: authorization,
                                                              cursor: query.cursor,
                                                              limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let request = SocialAPI.myFollowingGetTopicsWithRequestBuilder(authorization: authorization,
                                                                       cursor: query.cursor,
                                                                       limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = TopicsAPI.topicsGetPopularTopicsWithRequestBuilder(timeRange: query.timeRange,
                                                                         authorization: authorization,
                                                                         cursor: query.cursorInt(),
                                                                         limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = TopicsAPI.topicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                  cursor: query.cursor,
                                                                  limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = UsersAPI.userTopicsGetTopicsWithRequestBuilder(userHandle: query.user,
                                                                     authorization: authorization,
                                                                     cursor: query.cursor,
                                                                     limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = UsersAPI.userTopicsGetPopularTopicsWithRequestBuilder(userHandle: query.user,
                                                                            authorization: authorization,
                                                                            cursor: query.cursorInt(),
                                                                            limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopic(topicHandle: post, authorization: authorization) { (topic, error) in
            
            var result = PostFetchResult()
            
            guard let data = topic else {
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                } else {
                    let message = error?.localizedDescription ?? L10n.Error.noItemFor("\(post)")
                    result.error = FeedServiceError.failedToFetch(message: message)
                    completion(result)
                }
                return
            }
            
            result.posts = [Post(data: data)]
            completion(result)
        }
    }
    
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {
        
        let request = UsersAPI.myTopicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                   cursor: query.cursor,
                                                                   limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let request = UsersAPI.myTopicsGetPopularTopicsWithRequestBuilder(authorization: authorization,
                                                                          cursor: query.cursorInt(),
                                                                          limit: query.limit)
        
        processRequest(request, completion: completion)
    }
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        TopicsAPI.topicsDeleteTopic(topicHandle: post, authorization: authorization) { (object, errorResponse) in
            if let error = errorResponse {
                self.errorHandler.handle(error: error, completion: completion)
            } else {
                completion(.success())
            }
        }
    }
    
    // MARK: Private
    
    private func processRequest(_ requestBuilder:RequestBuilder<FeedResponseTopicView>,
                                completion: @escaping FetchResultHandler) {
        
        // Lookup in cache
        if let result = lookupInCache(by: requestCacheKey) {
            completion(result)
        }
        
        guard isNetworkReachable == true else { return }
        
        // Request execution
        requestBuilder.execute { (response, error) in
            
            var result = PostFetchResult()
            
            self.handleError(error, result: &result)
            self.cacheResponse(response?.body, forKey: requestBuilder.URLString)
            self.parseResponse(response?.body, into: &result)
            
            completion(result)
        }
    }
    
    private func cacheResponse(_ response: FeedResponseTopicView?, forKey key: String) {
        
        guard let response = response else { return }
        
        cache.cacheIncoming(response, for: key)
    }
    
    private func handleError(_ error: ErrorResponse?, result: inout PostFetchResult) {
        
        guard let error = error else { return }
        
        if errorHandler.canHandle(error) {
            errorHandler.handle(error)
        } else {
            let message = error.localizedDescription 
            result.error = FeedServiceError.failedToFetch(message: message)
        }
    }
    
    private func lookupInCache(by cacheKey: String) -> PostFetchResult? {
        
        guard let cachedResponse = cache.firstIncoming(ofType: FeedResponseTopicView.self, typeID: cacheKey) else {
            return nil
        }
        
        var result = PostFetchResult()
        
        self.parseResponse(cachedResponse, into: &result)
        
        return result
    }
    
    let responseParser = ResponseParser()
    
    private func parseResponse(_ response: FeedResponseTopicView?, into result: inout PostFetchResult) {
        responseParser.parse(response, into: &result)
    }
    
    class CachedFeedPostProcessor {
        
        func process(_ feed: inout PostFetchResult) {
            
        }
    }
    
    class ResponseParser {
        
        let postProcessor = CachedFeedPostProcessor()
        
        func parse(_ response: FeedResponseTopicView?, into result: inout PostFetchResult) {
            
            guard let response = response else { return }
            
            if let data = response.data {
                result.posts = data.map(Post.init)
            }
            result.cursor = response.cursor
            
            postProcessor.process(&result)
        }
    }
    
}

