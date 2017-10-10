//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//
import Foundation
import Alamofire

typealias TopicPosted = (Post) -> Void
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

typealias FetchResultHandler = ((FeedFetchResult) -> Void)

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
    func fetchUserRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchUserPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler)
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler)
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler)
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler)
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void))
    func postTopic(_ topic: Post, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure)
    func updateTopic(topicHandle: String, request: PutTopicRequest, success: @escaping () ->(), failure: @escaping (Error) ->() )
    
}

protocol PostServiceDelegate: class {
    
    func didFetchHome(query: FeedQuery, result: FeedFetchResult)
}

class TopicService: BaseService, PostServiceProtocol {

    private let imagesService: ImagesServiceType
    fileprivate let executorProvider: CacheRequestExecutorProviderType.Type
    private var topicsFeedExecutor: TopicsFeedRequestExecutor!
    private var otherUserTopicsFeedExecutor: TopicsFeedRequestExecutor!
    private var singlePostFetchExecuter: SingleTopicRequestExecutor!

    init(imagesService: ImagesServiceType,
         executorProvider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self) {
        
        self.imagesService = imagesService
        self.executorProvider = executorProvider

        super.init()
        
        topicsFeedExecutor = executorProvider.makeTopicsFeedExecutor(for: self)
        otherUserTopicsFeedExecutor = executorProvider.makeOtherUsersTopicsFeedExecutor(for: self)
        singlePostFetchExecuter = CacheRequestExecutorProvider.makeSinglePostExecutor(for: self)
    }
    
    func postTopic(_ topic: Post, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure) {
        let topicCommand = CreateTopicCommand(topic: topic)
        
        guard let image = photo?.image else {
            execute(command: topicCommand, success: success, failure: failure)
            return
        }
        
        imagesService.uploadTopicImage(image, topicHandle: topic.topicHandle) { [weak self] result in
            if let handle = result.value {
                topicCommand.setImageHandle(handle)
                self?.execute(command: topicCommand, success: success, failure: failure)
            } else if self?.errorHandler.canHandle(result.error) == true {
                self?.errorHandler.handle(result.error)
            } else {
                failure(result.error ?? APIError.unknown)
            }
        }
    }
    
    private func execute(command: CreateTopicCommand,
                         success: @escaping TopicPosted,
                         failure: @escaping Failure) {
        
        guard isNetworkReachable else {
            cache.cacheOutgoing(command)
            success(command.topic)
            return
        }
        
        let request = PostTopicRequest()
        request.text = command.topic.text
        request.title = command.topic.title
        
        if let imageHandle = command.topic.imageHandle {
            request.blobHandle = imageHandle
            request.blobType = .image
        }
        
        TopicsAPI.topicsPostTopic(request: request, authorization: authorization) { response, error in
            if let handle = response?.topicHandle {
                var topic = command.topic
                topic.topicHandle = handle
                success(topic)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
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
    
    // MARK: GET
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = PinsAPI.myPinsGetPinsWithRequestBuilder(authorization: authorization,
                                                              cursor: query.cursor,
                                                              limit: query.limit)
        execute(builder: builder, executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = SocialAPI.myFollowingGetTopicsWithRequestBuilder(authorization: authorization,
                                                                       cursor: query.cursor,
                                                                       limit: query.limit)
        execute(builder: builder, executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        let builder = TopicsAPI.topicsGetPopularTopicsWithRequestBuilder(timeRange: query.timeRange,
                                                                         authorization: authorization,
                                                                         cursor: query.cursorInt(),
                                                                         limit: query.limit)
        
        execute(builder: builder, executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = TopicsAPI.topicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                  cursor: query.cursor,
                                                                  limit: query.limit)
        
        execute(builder: builder, executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchUserRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.userTopicsGetTopicsWithRequestBuilder(userHandle: query.user,
                                                                     authorization: authorization,
                                                                     cursor: query.cursor,
                                                                     limit: query.limit)
        
        execute(builder: builder, executor: otherUserTopicsFeedExecutor, completion: completion)
    }
    
    func fetchUserPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.userTopicsGetPopularTopicsWithRequestBuilder(userHandle: query.user,
                                                                            authorization: authorization,
                                                                            cursor: query.cursorInt(),
                                                                            limit: query.limit)
        
        execute(builder: builder, executor: otherUserTopicsFeedExecutor, completion: completion)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        
        let request = TopicsAPI.topicsGetTopicWithRequestBuilder(topicHandle: post, authorization: authorization)
        
        singlePostFetchExecuter.execute(with: request) { (result) in
            var feedFetchResult = FeedFetchResult()
            
            guard let post = result.value else {
                feedFetchResult.error = result.error ?? APIError.missingUserData
                completion(feedFetchResult)
                return
            }
            
            feedFetchResult.posts = [post]
            completion(feedFetchResult)
        }
        
        TopicsAPI.topicsGetTopic(topicHandle: post, authorization: authorization) { (topic, error) in
            
            var result = FeedFetchResult()
            
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
            
            // get rid of nills
            result.posts = [Post(data: data)].flatMap { $0 }
            completion(result)
        }
    }
    
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.myTopicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                   cursor: query.cursor,
                                                                   limit: query.limit)
        
        execute(builder: builder, executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.myTopicsGetPopularTopicsWithRequestBuilder(authorization: authorization,
                                                                          cursor: query.cursorInt(),
                                                                          limit: query.limit)
        
        execute(builder: builder, executor: topicsFeedExecutor, completion: completion)
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
    
    private func execute(builder: RequestBuilder<FeedResponseTopicView>,
                         executor: TopicsFeedRequestExecutor,
                         completion: @escaping FetchResultHandler) {
        
        executor.execute(with: builder) { result in
            var feed = result.value ?? FeedFetchResult()
            if let error = result.error {
                feed.error = FeedServiceError.failedToFetch(message: error.localizedDescription)
            }
            completion(feed)
        }
    }
    
//    // MARK: Private
//    private func processRequest(_ requestBuilder:RequestBuilder<FeedResponseTopicView>,
//                                responseParser: FeedResponseParserType,
//                                completion: @escaping FetchResultHandler) {
//        
//        let requestCacheKey = requestBuilder.URLString
//        
//        // Lookup in cache and return if hit
//        if let result = fetchResultFromCache(by: requestCacheKey, responseParser: responseParser) {
//            
//            completion(result)
//        }
//        
//        guard isNetworkReachable == true else { return }
//        
//        // Request execution
//        requestBuilder.execute { [weak self] (response, error) in
//            
//            guard let strongSelf = self else { return }
//            
//            var result = FeedFetchResult()
//            
//            strongSelf.handleError(error, result: &result)
//            strongSelf.cacheResponse(response?.body, forKey: requestCacheKey)
//            responseParser.parse(response?.body, isCached: false, into: &result)
//            
//            completion(result)
//        }
//    }
//    
//    private func execute(builder: RequestBuilder<FeedResponseTopicView>,
//                         executor: TopicsFeedRequestExecutor,
//                         completion: @escaping FetchResultHandler) {
//        
//        executor.execute(with: builder) { result in
//            completion(result.value ?? FeedFetchResult())
//        }
//    }
//    
//    private func cacheResponse(_ response: FeedResponseTopicView?, forKey key: String) {
//        
//        guard let response = response else { return }
//        
//        cache.cacheIncoming(response, for: key)
//    }
//    
//    private func handleError(_ error: ErrorResponse?, result: inout FeedFetchResult) {
//        
//        guard let error = error else { return }
//        
//        if errorHandler.canHandle(error) {
//            errorHandler.handle(error)
//        } else {
//            let message = error.localizedDescription
//            result.error = FeedServiceError.failedToFetch(message: message)
//        }
//    }
}

