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
    func update(topic: Post, request: PutTopicRequest, success: @escaping () ->(), failure: @escaping (Error) ->())
    
}

protocol PostServiceDelegate: class {
    
    func didFetchHome(query: FeedQuery, result: FeedFetchResult)
}

class TopicService: BaseService, PostServiceProtocol {

    private let imagesService: ImagesServiceType
    fileprivate let executorProvider: CacheRequestExecutorProviderType.Type
    private var topicsFeedExecutor: TopicsFeedRequestExecutor!
    private var myRecentTopicsFeedExecutor: TopicsFeedRequestExecutor!
    private var singlePostFetchExecutor: SingleTopicRequestExecutor!
    private let predicateBuilder: PredicateBuilder
    private let changesPublisher: Publisher

    init(imagesService: ImagesServiceType,
         ExecutorProvider: CacheRequestExecutorProviderType.Type = CacheRequestExecutorProvider.self,
         predicateBuilder: PredicateBuilder = PredicateBuilder(),
         changesPublisher: Publisher = HandleChangesMulticast.shared) {
        
        self.imagesService = imagesService
        self.executorProvider = ExecutorProvider
        self.predicateBuilder = predicateBuilder
        self.changesPublisher = changesPublisher

        super.init()
        
        topicsFeedExecutor = ExecutorProvider.makeTopicsFeedExecutor(for: self)
        myRecentTopicsFeedExecutor = ExecutorProvider.makeMyRecentTopicsFeedExecutor(for: self)
        singlePostFetchExecutor = CacheRequestExecutorProvider.makeSinglePostExecutor(for: self)
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
        
        cache.cacheOutgoing(command)
        success(command.topic)
        
        let request = PostTopicRequest()
        request.text = command.topic.text
        request.title = command.topic.title
        
        if let imageHandle = command.topic.imageHandle {
            request.blobHandle = imageHandle
            request.blobType = .image
        }
        
        TopicsAPI.topicsPostTopic(request: request, authorization: authorization) { response, error in
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else if let handle = response?.topicHandle {
                self.onTopicPosted(oldCommand: command, newHandle: handle)
            }
        }
    }
    
    private func onTopicPosted(oldCommand cmd: CreateTopicCommand, newHandle: String) {
        cache.deleteOutgoing(with: predicateBuilder.predicate(for: cmd))
        
        let oldHandle: String = cmd.topic.topicHandle
        cache.cacheOutgoing(UpdateRelatedHandleCommand(oldHandle: oldHandle, newHandle: newHandle))
        
        changesPublisher.notify(TopicUpdateHint(oldHandle: oldHandle, newHandle: newHandle))
    }
    
    func update(topic: Post, request: PutTopicRequest, success: @escaping () -> (), failure: @escaping Failure) {
        var updatedTopic = topic
        updatedTopic.title = request.title
        updatedTopic.text = request.text
        let topicCommand = UpdateTopicCommand(topic: updatedTopic)
        execute(command: topicCommand, request: request, success: success, failure: failure)
    }
    
    private func execute(command: UpdateTopicCommand,
                         request: PutTopicRequest,
                         success: @escaping () -> (),
                         failure: @escaping Failure) {

        TopicsAPI.topicsPutTopic(
            topicHandle: command.topic.topicHandle,
            request: request,
            authorization: authorization) { object, error in
                
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                    failure(error ?? APIError.unknown)
                } else if error == nil {
                    success()
                } else {
                    self.cache.cacheOutgoing(command)
                    success()
                }
        }
    }
    
    // MARK: GET
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = PinsAPI.myPinsGetPinsWithRequestBuilder(authorization: authorization,
                                                              cursor: query.cursor,
                                                              limit: query.limit)
        execute(query: query, builder: builder, Executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = SocialAPI.myFollowingGetTopicsWithRequestBuilder(authorization: authorization,
                                                                       cursor: query.cursor,
                                                                       limit: query.limit)
        execute(query: query, builder: builder, Executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        let builder = TopicsAPI.topicsGetPopularTopicsWithRequestBuilder(timeRange: query.timeRange,
                                                                         authorization: authorization,
                                                                         cursor: query.cursorInt(),
                                                                         limit: query.limit)
        
        execute(query: query, builder: builder, Executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = TopicsAPI.topicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                  cursor: query.cursor,
                                                                  limit: query.limit)
        
        execute(query: query, builder: builder, Executor: myRecentTopicsFeedExecutor, completion: completion)
    }
    
    func fetchUserRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.userTopicsGetTopicsWithRequestBuilder(userHandle: query.user,
                                                                     authorization: authorization,
                                                                     cursor: query.cursor,
                                                                     limit: query.limit)
        
        execute(query: query, builder: builder, Executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchUserPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.userTopicsGetPopularTopicsWithRequestBuilder(userHandle: query.user,
                                                                            authorization: authorization,
                                                                            cursor: query.cursorInt(),
                                                                            limit: query.limit)
        
        execute(query: query, builder: builder, Executor: topicsFeedExecutor, completion: completion)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        
        let request = TopicsAPI.topicsGetTopicWithRequestBuilder(topicHandle: post, authorization: authorization)
        
        singlePostFetchExecutor.execute(with: request) { (result) in
            var feedFetchResult = FeedFetchResult()
            
            guard let post = result.value else {
                feedFetchResult.error = result.error ?? APIError.missingUserData
                completion(feedFetchResult)
                return
            }
            
            feedFetchResult.posts = [post]
            completion(feedFetchResult)
        }
        
    }
    
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.myTopicsGetTopicsWithRequestBuilder(authorization: authorization,
                                                                   cursor: query.cursor,
                                                                   limit: query.limit)
        
        execute(query: query, builder: builder, Executor: myRecentTopicsFeedExecutor, completion: completion)
    }
    
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {
        let builder = UsersAPI.myTopicsGetPopularTopicsWithRequestBuilder(authorization: authorization,
                                                                          cursor: query.cursorInt(),
                                                                          limit: query.limit)
        
        execute(query: query, builder: builder, Executor: topicsFeedExecutor, completion: completion)
    }
    
    private func execute(query: FeedQueryType,
                         builder: RequestBuilder<FeedResponseTopicView>,
                         Executor: TopicsFeedRequestExecutor,
                         completion: @escaping FetchResultHandler) {
        
        Executor.execute(with: builder) { result in
            var feed = result.value ?? FeedFetchResult()
            feed.query = query
            feed.error = result.error
            completion(feed)
        }
    }
    
    func deletePost(post topicHandle: PostHandle, completion: @escaping (Result<Void>) -> Void) {
        guard !isTopicCached(topicHandle: topicHandle) else {
            deleteCachedTopic(topicHandle: topicHandle)
            return
        }
        
        let command = RemoveTopicCommand(topic: Post(topicHandle: topicHandle))
        deleteTopic(command: command, completion: completion)
    }
    
    private func deleteTopic(command: RemoveTopicCommand, completion: @escaping (Result<Void>) -> Void) {
        cache.cacheOutgoing(command)
        
        TopicsAPI.topicsDeleteTopic(topicHandle: command.topic.topicHandle, authorization: authorization) { (_, error) in
            if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else if error == nil {
                let p = self.predicateBuilder.predicate(for: command)
                self.cache.deleteOutgoing(with: p)
                completion(.success())
            }
        }
    }
    
    private func isTopicCached(topicHandle: String) -> Bool {
        let p = cachedTopicPredicate(topicHandle: topicHandle)
        return cache.firstOutgoing(ofType: OutgoingCommand.self, predicate: p, sortDescriptors: nil) != nil
    }
    
    private func deleteCachedTopic(topicHandle: String) {
        let p = cachedTopicPredicate(topicHandle: topicHandle)
        cache.deleteOutgoing(with: p)
    }
    
    private func cachedTopicPredicate(topicHandle: String) -> NSPredicate {
        return predicateBuilder.predicate(typeID: CreateTopicCommand.typeIdentifier, handle: topicHandle)
    }
    
}

