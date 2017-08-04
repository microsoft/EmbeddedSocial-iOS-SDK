//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias PostHandle = String
typealias UserHandle = String

enum PostSocialAction: Int {
    case like, unlike, pin, unpin
}

protocol FeedModuleInteractorInput {
    
    func fetchPosts(limit: Int32?, feedType: FeedType)
    func fetchPostsMore(limit: Int32?, feedType: FeedType, cursor: String)
    
    func postAction(post: PostHandle, action: PostSocialAction)
}

protocol FeedModuleInteractorOutput: class {
    
    func didFetch(feed: PostsFeed)
    func didFetchMore(feed: PostsFeed)
    func didFail(error: FeedServiceError)
    func didStartFetching()
    func didFinishFetching()
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?)
}

class FeedModuleInteractor: FeedModuleInteractorInput {
    
    weak var output: FeedModuleInteractorOutput!
    var postService: PostServiceProtocol!
    var likesService: LikesServiceProtocol = LikesService()
    var pinsService: PinsServiceProtocol! = PinsService()
    var cachedFeedType: FeedType?
    
    var isFetching = false {
        didSet {
            isFetching ? output.didStartFetching() : output.didFinishFetching()
        }
    }
    
    var isLoadingMore = false

    private lazy var fetchHandler: FetchResultHandler = { [unowned self] result in
        
        self.isFetching = false
        
        guard result.error == nil else {
            self.output.didFail(error: result.error!)
            return
        }
        
        var feed = PostsFeed(items: result.posts, cursor: result.cursor)
        
        if self.isLoadingMore {
            self.output.didFetchMore(feed: feed)
        } else {
            self.output.didFetch(feed: feed)
        }
    }
    
    func fetchPostsMore(limit: Int32? = nil, feedType: FeedType, cursor: String) {
        fetchPosts(limit: limit, feedType: feedType, cursor: cursor)
    }
    
    func fetchPosts(limit: Int32? = nil, feedType: FeedType) {
        fetchPosts(limit: limit, feedType: feedType, cursor: nil)
    }
    
    private func fetchPosts(limit: Int32? = nil, feedType: FeedType, cursor: String?) {
        
        guard isFetching == false else {
            return
        }
        
        isLoadingMore = cursor != nil
        isFetching = true
   
        switch feedType {
            
        case .recent, .home:
            // TODO: use UserAPI for home feed fetch
            var query = RecentFeedQuery()
            query.limit = limit
            query.cursor = cursor
            postService.fetchRecent(query: query, completion: fetchHandler)
            
        case let .popular(type: range):
            var query = PopularFeedQuery()
            query.limit = limit
            query.cursor = (cursor == nil) ? nil : Int32(cursor!)
            
            switch range {
            case .alltime:
                query.timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.allTime
            case .today:
                query.timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.today
            case .weekly:
                query.timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.thisWeek
            }
            
            postService.fetchPopular(query: query, completion: fetchHandler)
            
        case let .user(user: user, scope: scope):
            var query = UserFeedQuery()
            query.limit = limit
            query.cursor = cursor
            query.user = user
            
            switch scope {
            case .popular:
                postService.fetchPopular(query: query, completion: fetchHandler)
            case .recent:
                postService.fetchRecent(query: query, completion: fetchHandler)
            }
            
        case let .single(post: post):
            postService.fetchPost(post: post, completion: fetchHandler)
        }
    }
    
    // MARK: Social Actions
    
    func postAction(post: PostHandle, action: PostSocialAction) {
        
        let completion:LikesServiceProtocol.CompletionHandler = { [weak self] (handle, err) in
            self?.output.didPostAction(post: post, action: action, error: err)
        }
        
        switch action {
        case .like:
            likesService.postLike(postHandle: post, completion: completion)
        case .unlike:
            likesService.deleteLike(postHandle: post, completion: completion)
        case .pin:
            pinsService.postPin(postHandle: post, completion: completion)
        case .unpin:
            pinsService.deletePin(postHandle: post, completion: completion)
        }
        
    }
}
