//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias PostHandle = String
typealias UserHandle = String

enum PostSocialAction: Int {
    case like, unlike, pin, unpin
}

struct FeedFetchRequest {
    var uid: String
    var cursor: String?
    var limit: Int32?
    var feedType: FeedType
}

protocol FeedModuleInteractorInput {
    func fetchPosts(request: FeedFetchRequest)
    func postAction(post: Post, action: PostSocialAction)
}

protocol FeedModuleInteractorOutput: class {
    func didFetch(feed: Feed)
    func didFetchMore(feed: Feed)
    func didFail(error: Error)
    func didStartFetching()
    func didFinishFetching()
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?)
}

class FeedModuleInteractor: FeedModuleInteractorInput {
    
    weak var output: FeedModuleInteractorOutput!
    var postService: PostServiceProtocol!
    var likesService: LikesServiceProtocol = LikesService()
    var searchService: SearchServiceType!
    weak var userHolder: UserHolder? = SocialPlus.shared
    
    func handleFetch(result: FeedFetchResult, request: FeedFetchRequest) {
        
        defer {
            output.didFinishFetching()
        }
        
        let isLoadingMore = request.cursor != nil
        
        guard result.error == nil else {
            output.didFail(error: result.error!)
            return
        }
        
        let feed = Feed(fetchID: request.uid, feedType: request.feedType, items: result.posts, cursor: result.cursor)
        
        if isLoadingMore {
           output.didFetchMore(feed: feed)
        } else {
           output.didFetch(feed: feed)
        }
    }
    
    func fetchPosts(request: FeedFetchRequest) {
        
        let isLoadingMore = request.cursor != nil
        let feedType = request.feedType
        let cursor = request.cursor
        let limit = request.limit
        
        Logger.log("Fetching: limit:\(String(describing: limit)) cursor:\(String(describing: cursor)) type:\(feedType) more: \(isLoadingMore)")
        
        output.didStartFetching()
        
        switch feedType {
            
        case .home:
            let query = FeedQuery(cursor: cursor, limit: limit)
            postService.fetchHome(query: query) { [weak self] result in
                self?.handleFetch(result: result, request: request)
            }
            
        case .recent:
            let query = FeedQuery(cursor: cursor, limit: limit)
            postService.fetchRecent(query: query) { [weak self] result in
                self?.handleFetch(result: result, request: request)
            }
            
        case let .popular(type: range):
            var query = PopularFeedQuery()
            query.limit = limit
            query.cursor = cursor
            
            switch range {
            case .alltime:
                query.timeRange = .allTime
            case .today:
                query.timeRange = .today
            case .weekly:
                query.timeRange = .thisWeek
            }
            
            postService.fetchPopular(query: query) { [weak self] result in
                self?.handleFetch(result: result, request: request)
            }
            
        case let .user(user: user, scope: scope):
            
            let isMyFeed = userHolder?.me?.isMyHandle(user) == true
            
            if isMyFeed {
                let query = FeedQuery(cursor: cursor, limit: limit)
                
                switch scope {
                case .popular:
                    postService.fetchMyPopular(query: query) { [weak self] result in
                        self?.handleFetch(result: result, request: request)
                    }

                case .recent:
                    postService.fetchMyPosts(query: query) { [weak self] result in
                        self?.handleFetch(result: result, request: request)
                    }
                }
            }
            else {
                var query = UserFeedQuery()
                query.limit = limit
                query.cursor = cursor
                query.user = user
                
                switch scope {
                case .popular:
                    postService.fetchUserPopular(query: query) { [weak self] result in
                        self?.handleFetch(result: result, request: request)
                    }
                case .recent:
                    postService.fetchUserRecent(query: query) { [weak self] result in
                        self?.handleFetch(result: result, request: request)
                    }
                }
            }
            
        case let .single(post: post):
            postService.fetchPost(post: post) { [weak self] result in
                self?.handleFetch(result: result, request: request)
            }
            
        case let .search(query):
            searchService.queryTopics(query: query ?? "", cursor: cursor, limit: Constants.Feed.pageSize) { [weak self] result in
                let result = result.value ?? FeedFetchResult(error: result.error ?? APIError.unknown)
                self?.handleFetch(result: result, request: request)
            }
            
        case .myPins:
            let query = FeedQuery(cursor: cursor, limit: limit)
            postService.fetchMyPins(query: query, completion: { [weak self] result in
                self?.handleFetch(result: result, request: request)
            })
        }
    }
    
    // MARK: Social Actions
    
    func postAction(post: Post, action: PostSocialAction) {
        
        let completion: LikesServiceProtocol.CompletionHandler = { [weak self] (handle, err) in
            self?.output.didPostAction(post: post.topicHandle, action: action, error: err)
        }
        
        switch action {
        case .like:
            likesService.postLike(post: post, completion: completion)
        case .unlike:
            likesService.deleteLike(post: post, completion: completion)
        case .pin:
            likesService.postPin(post: post, completion: completion)
        case .unpin:
            likesService.deletePin(post: post, completion: completion)
        }
        
    }
    
    deinit {
        Logger.log()
    }
}
