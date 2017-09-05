//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class PostServiceMock: PostServiceProtocol {
    
    //MARK: - fetchHome
    
    var fetchHomeQueryCompletionCalled = false
    var fetchHomeQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchHomeQueryCompletionCalled = true
        fetchHomeQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchPopular
    
    var fetchPopularQueryCompletionCalled = false
    var fetchPopularQueryCompletionReceivedArguments: (query: PopularFeedQuery, completion: FetchResultHandler)?
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        fetchPopularQueryCompletionCalled = true
        fetchPopularQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchRecent
    
    var fetchRecentQueryCompletionCalled = false
    var fetchRecentQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchRecentQueryCompletionCalled = true
        fetchRecentQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchUserRecent
    
    var fetchUserRecentQueryCompletionCalled = false
    var fetchUserRecentQueryCompletionReceivedArguments: (query: UserFeedQuery, completion: FetchResultHandler)?
    
    func fetchUserRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchUserRecentQueryCompletionCalled = true
        fetchUserRecentQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchUserPopular
    
    var fetchUserPopularQueryCompletionCalled = false
    var fetchUserPopularQueryCompletionReceivedArguments: (query: UserFeedQuery, completion: FetchResultHandler)?
    
    func fetchUserPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchUserPopularQueryCompletionCalled = true
        fetchUserPopularQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchPost
    
    var fetchPostPostCompletionCalled = false
    var fetchPostPostCompletionReceivedArguments: (post: PostHandle, completion: FetchResultHandler)?
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        fetchPostPostCompletionCalled = true
        fetchPostPostCompletionReceivedArguments = (post: post, completion: completion)
    }
    
    //MARK: - fetchMyPosts
    
    var fetchMyPostsQueryCompletionCalled = false
    var fetchMyPostsQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPostsQueryCompletionCalled = true
        fetchMyPostsQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchMyPopular
    
    var fetchMyPopularQueryCompletionCalled = false
    var fetchMyPopularQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPopularQueryCompletionCalled = true
        fetchMyPopularQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchMyPins
    
    var fetchMyPinsQueryCompletionCalled = false
    var fetchMyPinsQueryCompletionReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPins(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPinsQueryCompletionCalled = true
        fetchMyPinsQueryCompletionReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - deletePost
    
    var deletePostPostCompletionCalled = false
    var deletePostPostCompletionReceivedArguments: (post: PostHandle, completion: (Result<Void>) -> Void)?
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        deletePostPostCompletionCalled = true
        deletePostPostCompletionReceivedArguments = (post: post, completion: completion)
    }
    
}
