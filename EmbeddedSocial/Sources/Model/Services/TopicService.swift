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

struct PopularFeedQuery {
    var cursor: Int32?
    var limit: Int32?
    var timeRange: TopicsAPI.TimeRange_topicsGetPopularTopics!
}

struct RecentFeedQuery {
    var cursor: String?
    var limit: Int32?
}

struct UserFeedQuery {
    var cursor: String?
    var limit: Int32?
    var user: UserHandle!
}

struct HomeFeedQuery {
    var cursor: String?
    var limit: Int32?
}

protocol PostServiceProtocol {
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler)
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler)
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler)
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void))
}

class TopicService: BaseService, PostServiceProtocol {

    private var imagesService: ImagesServiceType!
    
    init(imagesService: ImagesServiceType) {
        super.init()
        self.imagesService = imagesService
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
    
    private func cacheTopic(_ topic: PostTopicRequest, with photo: Photo?) {
        if let photo = photo {
            cache.cacheOutgoing(object: photo)
            topic.blobHandle = photo.uid
        }
        cache.cacheOutgoing(object: topic)
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
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler) {
        SocialAPI.myFollowingGetTopics(
            authorization: authorization,
            cursor: query.cursor,
            limit: query.limit) { response, error in
                self.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetPopularTopics(
            timeRange: query.timeRange,
            authorization: authorization,
            cursor: query.cursor,
            limit: query.limit) { response, error in
                self.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopics(
            authorization: authorization,
            cursor: query.cursor,
            limit: query.limit) { response, error in
                self.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        UsersAPI.userTopicsGetTopics(
            userHandle: query.user,
            authorization: authorization,
            cursor: query.cursor,
            limit: query.limit) { response, error in
                self.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        UsersAPI.userTopicsGetPopularTopics(userHandle: query.user, authorization: authorization) { response, error in
            self.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopic(topicHandle: post, authorization: authorization) { (topic, error) in
            
            var result = PostFetchResult()
            
            guard let data = topic else {
                if self.errorHandler.canHandle(error) {
                    self.errorHandler.handle(error)
                } else {
                    result.error = FeedServiceError.failedToFetch(message: error?.localizedDescription ?? "No item for \(post)")
                    completion(result)
                }
                return
            }
            
            result.posts = [Post(data: data)]
            completion(result)
        }
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
    
    private func parseResponse(response: FeedResponseTopicView?, error: Error?, completion: FetchResultHandler) {
        var result = PostFetchResult()

        guard let data = response?.data else {
            if errorHandler.canHandle(error) {
                errorHandler.handle(error)
            } else {
                result.error = FeedServiceError.failedToFetch(message: error?.localizedDescription ?? "No Items Received")
                completion(result)
            }
            return
        }
        
        result.posts = data.map(Post.init)
        result.cursor = response?.cursor
        
        completion(result)
    }
}
