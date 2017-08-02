//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias PostHandle = String
typealias UserHandle = String

enum PostSocialAction {
    case like, unlike, pin, unpin
}

protocol FeedModuleInteractorInput {
    
    func fetchPosts(limit: Int32?, feedType: FeedType)
    func postAction(post: PostHandle, action: PostSocialAction)
}

protocol FeedModuleInteractorOutput: class {
    
    func didFetch(feed: PostsFeed)
    func didFetchMore(feed: PostsFeed)
    func didFail(error: FeedServiceError)
    
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
            Logger.log(isFetching)
        }
    }
    private var cursor: String? = nil {
        didSet {
            Logger.log(cursor)
        }
    }
    
    private lazy var fetchHandler: FetchResultHandler = { [unowned self] result in
        
        self.isFetching = false
        
        guard result.error == nil else {
            self.output.didFail(error: result.error!)
            return
        }
        
        let feed = PostsFeed(items: result.posts)
        
        if self.cursor == nil {
            self.output.didFetch(feed: feed)
        } else {
            self.output.didFetchMore(feed: feed)
        }
        
        self.cursor = result.cursor
    }
    
    func fetchPosts(limit: Int32? = nil, feedType: FeedType) {
        
        isFetching = true
        
        if cachedFeedType != feedType {
            // clean
            self.cursor = nil
        }
        
        cachedFeedType = feedType
        
        switch feedType {
            
        case .recent, .home:
            // TODO: use UserAPI for home feed fetch
            var query = RecentFeedQuery()
            query.limit = limit
            query.cursor = self.cursor
            postService.fetchRecent(query: query, completion: fetchHandler)
            
        case let .popular(type: range):
            var query = PopularFeedQuery()
            query.limit = limit
            query.cursor = self.cursor == nil ? nil : Int32(self.cursor!)
            
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
