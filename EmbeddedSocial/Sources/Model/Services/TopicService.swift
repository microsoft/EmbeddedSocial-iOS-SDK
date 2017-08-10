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
    
}

class TopicService: PostServiceProtocol {
    private let cache: CacheType
    private let errorHandler: APIErrorHandler
    
    init(cache: CacheType, errorHandler: APIErrorHandler = UnauthorizedErrorHandler()) {
        self.cache = cache
        self.errorHandler = errorHandler
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
        
        postImage(image) { [unowned self] handle, error in
            if let handle = handle {
                topic.blobHandle = handle
                self.postTopic(request: topic, success: success, failure: failure)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
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
        TopicsAPI.topicsPostTopic(request: request) { [unowned self] response, error in
            if response != nil {
                success(request)
            } else if self.errorHandler.canHandle(error) {
                self.errorHandler.handle(error)
            } else {
                failure(error ?? APIError.unknown)
            }
        }
    }
    
    private func postImage(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        guard let imageData = UIImageJPEGRepresentation(image, Constants.imageCompressionQuality) else {
            completion(nil, APIError.custom("Image is invalid"))
            return
        }
        
        ImagesAPI.imagesPostImage(imageType: .contentBlob, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!,
        image: imageData, imageFileType: "image/jpeg") { [weak self] response, error in
            completion(response?.blobHandle, error)
        }


        ImagesAPI.imagesPostImage(imageType: .contentBlob, image: imageData) { response, error in
            completion(response?.blobHandle, error)
        }
    }
    
    // MARK: GET
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler) {
        SocialAPI.myFollowingGetFollowingTopics(authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!, cursor: query.cursor, limit: query.limit) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetPopularTopics(timeRange: query.timeRange, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!,
                                         cursor: query.cursor,
                                         limit: query.limit) { [weak self] response, error in
                                            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopics(authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!, cursor: query.cursor, limit: query.limit) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        UsersAPI.userTopicsGetTopics(userHandle: query.user, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!, cursor: query.cursor, limit: query.limit) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        UsersAPI.userTopicsGetPopularTopics(userHandle: query.user, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!) { [weak self] response, error in
            self?.parseResponse(response: response, error: error, completion: completion)
        }
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        TopicsAPI.topicsGetTopic(topicHandle: post, authorization: (SocialPlus.shared.sessionStore.user.credentials?.authHeader.values.first)!) { (topic, error) in
            
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
