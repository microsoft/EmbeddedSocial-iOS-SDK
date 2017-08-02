//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias PostHandle = String
typealias UserHandle = String

protocol HomeInteractorInput {
    
    func fetchPosts(limit: Int32?, cursor: String?, type: FeedType)
    
    func like(with id: PostHandle)
    func unlike(with id: PostHandle)
    func pin(with id: PostHandle)
    func unpin(with id: PostHandle)
}

protocol HomeInteractorOutput: class {
    
    func didFetch(feed: PostsFeed)
    func didFetchMore(feed: PostsFeed, cursor: String?)
    func didFail(error: FeedServiceError)
    
    func didLike(post id: PostHandle)
    func didUnlike(post id: PostHandle)
    func didUnpin(post id: PostHandle)
    func didPin(post id: PostHandle)
}

class HomeInteractor: HomeInteractorInput {
    
    weak var output: HomeInteractorOutput!
    var postService: PostServiceProtocol!
    var likesService: LikesServiceProtocol = LikesService()
    var pinsService: PinsServiceProtocol! = PinsService()
    
    var isFetching = false
    private var fetchingCursor: String? = nil
    
    private lazy var fetchHandler: FetchResultHandler = { [unowned self] result in
        
        self.isFetching = false
        
        guard result.error == nil else {
            self.output.didFail(error: result.error!)
            return
        }
        
        let feed = PostsFeed(items: result.posts)
        
        if self.fetchingCursor == nil {
            self.output.didFetch(feed: feed)
        } else {
            self.output.didFetchMore(feed: feed, cursor: result.cursor)
        }
    }
    
    func fetchPosts(limit: Int32? = nil, cursor: String? = nil, type: FeedType) {
    
        fetchingCursor = cursor
        isFetching = true
        
        switch type {
            
        case .recent, .home:
            // TODO: use UserAPI for home feed fetch
            var query = RecentFeedQuery()
            query.limit = limit
            query.cursor = cursor
            postService.fetchRecent(query: query, completion: fetchHandler)

        case let .popular(type: range):
            var query = PopularFeedQuery()
            query.limit = limit
            query.cursor = nil
            
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
                postService.fetchRecent(query: query, completion: fetchHandler)
            case .recent:
                postService.fetchRecent(query: query, completion: fetchHandler)
            }
            
        case let .single(post: post):
            postService.fetchPost(post: post, completion: fetchHandler)
        }
    }

    // TODO: refactor these methods using generics ?
    
    func unlike(with id: PostHandle) {
        likesService.deleteLike(postHandle: id) { (handle, err) in
            guard err == nil else {
                self.output.didFail(error: FeedServiceError.failedToUnLike(message: err!.localizedDescription))
                return
            }
            
            self.output.didUnlike(post: handle)
        }
    }
    
    func unpin(with id: PostHandle) {
        pinsService.deletePin(postHandle: id) { (handle, err) in
            guard err == nil else {
                self.output.didFail(error: FeedServiceError.failedToUnPin(message: err!.localizedDescription))
                return
            }
            
            self.output.didUnpin(post: handle)
        }
    }
    
    func pin(with id: PostHandle) {
        pinsService.postPin(postHandle: id) { (handle, err) in
            guard err == nil else {
                self.output.didFail(error: FeedServiceError.failedToPin(message: err!.localizedDescription))
                return
            }
            
            self.output.didPin(post: handle)
        }
    }
    
    func like(with id: PostHandle) {
        
        likesService.postLike(postHandle: id) { (handle, err) in
            guard err == nil else {
                self.output.didFail(error: FeedServiceError.failedToLike(message: err!.localizedDescription))
                return
            }
            
            self.output.didLike(post: handle)
        }
    }
}
