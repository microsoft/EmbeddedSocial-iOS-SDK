//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class PostServiceProtocolMock: PostServiceProtocol {
    
    //MARK: - fetchHome
    
    var fetchHome_query_completion_Called = false
    var fetchHome_query_completion_ReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchHome(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchHome_query_completion_Called = true
        fetchHome_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchPopular
    
    var fetchPopular_query_completion_Called = false
    var fetchPopular_query_completion_ReceivedArguments: (query: PopularFeedQuery, completion: FetchResultHandler)?
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        fetchPopular_query_completion_Called = true
        fetchPopular_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchRecent
    
    var fetchRecent_query_completion_Called = false
    var fetchRecent_query_completion_ReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchRecent(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchRecent_query_completion_Called = true
        fetchRecent_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchRecent
    
    var fetchRecent_query_completion_Called = false
    var fetchRecent_query_completion_ReceivedArguments: (query: UserFeedQuery, completion: FetchResultHandler)?
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchRecent_query_completion_Called = true
        fetchRecent_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchPopular
    
    var fetchPopular_query_completion_Called = false
    var fetchPopular_query_completion_ReceivedArguments: (query: UserFeedQuery, completion: FetchResultHandler)?
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchPopular_query_completion_Called = true
        fetchPopular_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchPost
    
    var fetchPost_post_completion_Called = false
    var fetchPost_post_completion_ReceivedArguments: (post: PostHandle, completion: FetchResultHandler)?
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        fetchPost_post_completion_Called = true
        fetchPost_post_completion_ReceivedArguments = (post: post, completion: completion)
    }
    
    //MARK: - fetchMyPosts
    
    var fetchMyPosts_query_completion_Called = false
    var fetchMyPosts_query_completion_ReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPosts(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPosts_query_completion_Called = true
        fetchMyPosts_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - fetchMyPopular
    
    var fetchMyPopular_query_completion_Called = false
    var fetchMyPopular_query_completion_ReceivedArguments: (query: FeedQuery, completion: FetchResultHandler)?
    
    func fetchMyPopular(query: FeedQuery, completion: @escaping FetchResultHandler) {
        fetchMyPopular_query_completion_Called = true
        fetchMyPopular_query_completion_ReceivedArguments = (query: query, completion: completion)
    }
    
    //MARK: - deletePost
    
    var deletePost_post_completion_Called = false
    var deletePost_post_completion_ReceivedArguments: (post: PostHandle, completion: (Result<Void>) -> Void)?
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        deletePost_post_completion_Called = true
        deletePost_post_completion_ReceivedArguments = (post: post, completion: completion)
    }
    
}
