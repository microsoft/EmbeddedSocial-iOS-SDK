//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

typealias PostHandle = String
typealias UserHandle = String

protocol HomeInteractorInput {
    
    func fetchPosts(limit: Int?, cursor: String?, type: FeedType)
    
    func like(with id: PostHandle)
    func unlike(with id: PostHandle)
    func pin(with id: PostHandle)
    func unpin(with id: PostHandle)
    
}

protocol HomeInteractorOutput: class {
    
    func didFetch(feed: PostsFeed)
    func didFetchMore(feed: PostsFeed)
    func didFail(error: FeedServiceError)
    
    func didLike(post id: PostHandle)
    func didUnlike(post id: PostHandle)
    func didUnpin(post id: PostHandle)
    func didPin(post id: PostHandle)
}

class HomeInteractor: HomeInteractorInput {
    
    weak var output: HomeInteractorOutput!
    var postService: PostServiceProtocol! = TopicService(cache: SocialPlus.shared.cache)
    var likesService: LikesServiceProtocol = LikesService()
    var pinsService: PinsServiceProtocol! = PinsService()
    
    private var offset: String? = nil
    
    private lazy var fetchHandler: FetchResultHandler = { [unowned self] result in
        
        guard result.error == nil else {
            self.output.didFail(error: result.error!)
            return
        }
        
        let feed = PostsFeed(items: result.posts)
        
        if self.offset == nil {
            self.output.didFetch(feed: feed)
        } else {
            self.output.didFetchMore(feed: feed)
        }
        
        self.offset = result.cursor
    }
    
    
    func fetchPosts(limit: Int? = nil, cursor: String? = nil, type: FeedType) {
        
        switch type {
        case .home:
             print(type)
        case .recent:
            var query = RecentFeedQuery()
            query.limit = limit != nil ? Int32(limit!) : nil
            query.cursor = cursor
            postService.fetchRecent(query: query, result: fetchHandler)

        case let .popular(type: range):
            var query = PopularFeedQuery()
            query.limit = limit != nil ? Int32(limit!) : nil
            query.cursor = nil
            
            switch range {
            case .alltime:
                query.timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.allTime
            case .today:
                query.timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.today
            case .weekly:
                query.timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.thisWeek
            }
            
            postService.fetchPopular(query: query, result: fetchHandler)
            
        case let .single(post: post):
            print(post)
        
        case .user(let user, let scope):
            print(user, scope)
        }
        
        
        
    }
    
    //
    //        switch type {
    //        case let .home(cursor, limit):
    //            var query = RecentFeedQuery()
    //            query.limit = Intcursor
    //            query.limit = limit
    //            postService.fetchRecent(query: <#T##RecentFeedQuery#>, result: <#T##FetchResultHandler##FetchResultHandler##(PostFetchResult) -> Void#>)
    //        default:
    //
    //        }
    
    
    //        postService.fetchPosts(offset: offset, limit: limit) { (result) in
    //
    //            guard result.error == nil else {
    //
    //                self.output.didFail(error: result.error!)
    //
    //                return
    //            }
    //
    //            let feed = PostsFeed(items: result.posts)
    //
    //            if self.offset == nil {
    //                self.output.didFetch(feed: feed)
    //            } else {
    //                self.output.didFetchMore(feed: feed)
    //            }
    //
    //            self.offset = result.cursor
    //        }
    
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

//extension HomeInteractor {
//    private func fetchFeed() {

//        
//        let cursor:Int32? = Int32(fetchRequest.cursor ?? "")
//        var timeRange: TopicsAPI.TimeRange_topicsGetPopularTopics?
//        let limit: Int32? = Int32(fetchRequest.limit)
//        
//        guard case let FeedType.popular(type: feedRange) = fetchRequest.feedType else {
//            fatalError("Wrong method is called")
//        }
//        
//        switch feedRange {
//        case .alltime:
//            timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.allTime
//        case .today:
//            timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.today
//        case .weekly:
//            timeRange = TopicsAPI.TimeRange_topicsGetPopularTopics.thisWeek
//        }
//        


//    }
//}

