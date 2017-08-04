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

protocol PostServiceProtocol {
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler)
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler)
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler)
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler)
    
}

class TopicService: PostServiceProtocol {
    
    private var success: TopicPosted?
    private var failure: Failure?
    
    private var cache: Cachable!
    
    // MARK: Public
    init(cache: Cachable) {
        self.cache = cache
    }
    
    // MARK: POST
    
    func postTopic(topic: PostTopicRequest, photo: Photo?, success: @escaping TopicPosted, failure: @escaping Failure) {
        self.success = success
        self.failure = failure
        
        guard let network = NetworkReachabilityManager() else {
            return
        }
        
        if network.isReachable {
            guard let image = photo?.image else {
                sendPostTopicRequest(request: topic)
                return
            }
            
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
                return
            }
            
            ImagesAPI.imagesPostImage(imageType: ImagesAPI.ImageType_imagesPostImage.contentBlob,
                                      image: imageData) { [weak self] (response, error) in
                                        guard let blobHandle = response?.blobHandle else {
                                            if let unwrappedError = error {
                                                failure(unwrappedError)
                                            }
                                            return
                                        }
                                        
                                        topic.blobHandle = blobHandle
                                        self?.sendPostTopicRequest(request: topic)
            }
            
        } else {
            if photo != nil {
                cache?.cacheOutgoing(object: photo!)
                topic.blobHandle = photo?.url
            }
            
            cache?.cacheOutgoing(object: topic)
        }
    }
    
    private func sendPostTopicRequest(request: PostTopicRequest) {
        TopicsAPI.topicsPostTopic(request: request) { [weak self] (response, error) in
            guard response != nil else {
                self?.failure!(error!)
                return
            }
            
            self?.success!(request)
        }
    }
    
    // MARK: GET
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetPopularTopics(timeRange: query.timeRange,
                                         cursor: query.cursor,
                                         limit: query.limit) { [weak self] response, error in
                                            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopics(cursor: query.cursor, limit: query.limit) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        UsersAPI.userTopicsGetTopics(userHandle: query.user, cursor: query.cursor, limit: query.limit) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        UsersAPI.userTopicsGetPopularTopics(userHandle: query.user) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopic(topicHandle: post) { [weak self] (topic, error) in
            
            var result = PostFetchResult()
            
            guard error == nil else {
                result.error = FeedServiceError.failedToFetch(message: error!.localizedDescription)
                completion(result)
                return
            }
            
            guard let data = topic else {
                result.error = FeedServiceError.failedToFetch(message: "No item for \(post)")
                completion(result)
                return
            }
            
            if let wself = self {
                result.posts = wself.convert(data: [data])
            }
            
            completion(result)
        }
    }
    
    private func parseResponse(response: FeedResponseTopicView?, error: Error?, completion: FetchResultHandler) {
        var result = PostFetchResult()
        
        guard error == nil else {
            result.error = FeedServiceError.failedToFetch(message: error!.localizedDescription)
            completion(result)
            return
        }
        
        guard let data = response?.data else {
            result.error = FeedServiceError.failedToFetch(message: "No Items Received")
            completion(result)
            return
        }
        
        result.posts = self.convert(data: data)
        result.cursor = response?.cursor
        
        completion(result)
    }
    
    // MARK: Private
    private func convert(data: [TopicView]) -> [Post] {
        
        var posts = [Post]()
        for item in data {
            var post = Post()
            post.firstName = item.user?.firstName
            post.lastName = item.user?.lastName
            post.photoUrl = item.user?.photoUrl
            post.userHandle = item.user?.userHandle
            
            post.createdTime = item.createdTime
            post.imageUrl = item.blobUrl
            post.title = item.title
            post.text = item.text
            post.pinned = item.pinned ?? false
            post.liked = item.liked ?? false
            post.topicHandle = item.topicHandle
            post.totalLikes = item.totalLikes ?? 0
            post.totalComments = item.totalComments ?? 0
            // TODO: fullfill mapping
            posts.append(post)
        }
        return posts
    }
}
