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
    
    func fetchPosts(limit: Int32?, cursor: String?, feedType: FeedType)
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
    weak var userHolder: UserHolder? = SocialPlus.shared
    
    func handleFetch(result: PostFetchResult, feedType: FeedType, isLoadingMore: Bool = false) {
        
        output.didFinishFetching()
        
        guard result.error == nil else {
            output.didFail(error: result.error!)
            return
        }
        
        let feed = PostsFeed(feedType: feedType, items: result.posts, cursor: result.cursor)
        
        if isLoadingMore {
           output.didFetchMore(feed: feed)
        } else {
           output.didFetch(feed: feed)
        }
    }
    
    func fetchPosts(limit: Int32? = nil, cursor: String? = nil, feedType: FeedType) {
        
        let isLoadingMore = cursor != nil
        output.didStartFetching()
        
        switch feedType {
            
        case .home:
            var query = HomeFeedQuery()
            query.limit = limit
            query.cursor = cursor
            postService.fetchHome(query: query) { [weak self] result in
                self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
            }
            
        case .recent:
            var query = RecentFeedQuery()
            query.limit = limit
            query.cursor = cursor
            postService.fetchRecent(query: query) { [weak self] result in
                self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
            }
            
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
            
            postService.fetchPopular(query: query) { [weak self] result in
                self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
            }
            
        case let .user(user: user, scope: scope):
            
            let isMyFeed = userHolder?.me?.isMyHandle(user) == true
            
            if isMyFeed {
                var query = MyFeedQuery()
                query.cursor = cursor
                query.limit = limit
                
                switch scope {
                case .popular:
                    postService.fetchMyPopular(query: query) { [weak self] result in
                        self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
                    }

                case .recent:
                    postService.fetchMyPosts(query: query) { [weak self] result in
                        self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
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
                    postService.fetchPopular(query: query) { [weak self] result in
                        self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
                    }
                case .recent:
                    postService.fetchRecent(query: query) { [weak self] result in
                        self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
                    }
                }
            }
            
        case let .single(post: post):
            postService.fetchPost(post: post) { [weak self] result in
                self?.handleFetch(result: result, feedType: feedType, isLoadingMore: isLoadingMore)
            }
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
    
    deinit {
        Logger.log()
    }
}
