//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class PostServiceMock: PostServiceProtocol {
    
    //MARK: - fetchHome
    
    var fetchHomeQueryCompletion: PostFetchResult!
    var fetchHomeQueryCompletionCalled = false
    var fetchHomeQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchHomeQueryCompletionCalled = true
        fetchHomeQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchHomeQueryCompletion != nil {
            completion(fetchHomeQueryCompletion)
        }
    }
    
    //MARK: - fetchPopular
    
    var fetchPopularQueryCompletion: PostFetchResult!
    var fetchPopularQueryCompletionCalled = false
    var fetchPopularQueryCompletionReceivedArguments: (query: PopularFeedQuery, completion: FetchResultHandler)?
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        fetchPopularQueryCompletionCalled = true
        fetchPopularQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchPopularQueryCompletion != nil {
            completion(fetchPopularQueryCompletion)
        }
    }
    
    //MARK: - fetchRecent
    
    var fetchRecentQueryCompletion: PostFetchResult!
    var fetchRecentQueryCompletionCalled = false
    var fetchRecentQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchRecentQueryCompletionCalled = true
        fetchRecentQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchRecentQueryCompletion != nil {
            completion(fetchRecentQueryCompletion)
        }
    }
    
    //MARK: - fetchUserRecent
    
    var fetchUserRecentQueryCompletion: PostFetchResult!
    var fetchUserRecentQueryCompletionCalled = false
    var fetchUserRecentQueryCompletionReceivedArguments: (query: UserFeedQuery, completion: FetchResultHandler)?
    
    func fetchUserRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchUserRecentQueryCompletionCalled = true
        fetchUserRecentQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchUserRecentQueryCompletion != nil {
            completion(fetchUserRecentQueryCompletion)
        }
    }
    
    //MARK: - fetchUserPopular
    
    var fetchUserPopularQueryCompletion: PostFetchResult!
    var fetchUserPopularQueryCompletionCalled = false
    var fetchUserPopularQueryCompletionReceivedArguments: (query: UserFeedQuery, completion: FetchResultHandler)?
    
    func fetchUserPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchUserPopularQueryCompletionCalled = true
        fetchUserPopularQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchUserPopularQueryCompletion != nil {
            completion(fetchUserPopularQueryCompletion)
        }
    }
    
    //MARK: - fetchPost
    
    var fetchPostPostCompletion: PostFetchResult!
    var fetchPostPostCompletionCalled = false
    var fetchPostPostCompletionReceivedArguments: (post: PostHandle, completion: FetchResultHandler)?
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        fetchPostPostCompletionCalled = true
        fetchPostPostCompletionReceivedArguments = (post: post, completion: completion)
        
        if fetchPostPostCompletion != nil {
            completion(fetchPostPostCompletion)
        }
    }
    
    //MARK: - fetchMyPosts
    
    var fetchMyPostsQueryCompletion: PostFetchResult!
    var fetchMyPostsQueryCompletionCalled = false
    var fetchMyPostsQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPostsQueryCompletionCalled = true
        fetchMyPostsQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchMyPostsQueryCompletion != nil {
            completion(fetchMyPostsQueryCompletion)
        }
    }
    
    //MARK: - fetchMyPopular
    
    var fetchMyPopularQueryCompletion: PostFetchResult!
    var fetchMyPopularQueryCompletionCalled = false
    var fetchMyPopularQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPopularQueryCompletionCalled = true
        fetchMyPopularQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchMyPopularQueryCompletion != nil {
            completion(fetchMyPopularQueryCompletion)
        }
    }
    
    //MARK: - fetchMyPins
    
    var fetchMyPinsQueryCompletion: PostFetchResult!
    var fetchMyPinsQueryCompletionCalled = false
    var fetchMyPinsQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPinsQueryCompletionCalled = true
        fetchMyPinsQueryCompletionReceivedArguments = (query: query, completion: completion)
        
        if fetchMyPinsQueryCompletion != nil {
            completion(fetchMyPinsQueryCompletion)
        }
    }
    
    //MARK: - deletePost
    
    var deletePostPostCompletionCalled = false
    var deletePostPostCompletionReceivedArguments: (post: PostHandle, completion: (Result<Void>) -> Void)?
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        deletePostPostCompletionCalled = true
        deletePostPostCompletionReceivedArguments = (post: post, completion: completion)
        
    }
    
}
