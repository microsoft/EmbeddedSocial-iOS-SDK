//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class MockPostService: PostServiceProtocol {
    
    var fetchPopularIsCalled = false
    var fetchPopularQuery: PopularFeedQuery?
    
    var fetchHomeIsCalled = false
    var fetchHomeQuery: HomeFeedQuery?
    
    var fetchRecentIsCalled = false
    var fetchRecentQuery: RecentFeedQuery?
    
    var fetchRecentForUserIsCalled = false
    var fetchRecentForUserQuery: UserFeedQuery?
    
    var fetchPopularForUserIsCalled = false
    var fetchPopularForUserQuery: UserFeedQuery?
    
    var fetchPostIsCalled = false
    var fetchPostHandle: PostHandle?
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler) {
        fetchHomeIsCalled = true
        fetchHomeQuery = query
    }
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        fetchPopularIsCalled = true
        fetchPopularQuery = query
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        fetchRecentIsCalled = true
        fetchRecentQuery = query
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchRecentForUserIsCalled = true
        fetchRecentForUserQuery = query
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        fetchPopularForUserIsCalled = true
        fetchPopularForUserQuery = query
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        fetchPostIsCalled = true
        fetchPostHandle = post
    }
    
    func fetchMyPosts(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        
    }
    
    func fetchMyPopular(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        
    }
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        
    }
}

class FeedModuleInteractor_FetchQuery_Tests: XCTestCase {
    
    var sut: FeedModuleInteractor!
    private var postService: MockPostService!
    var presenter: FeedModulePresenter!
    var view: FeedModuleViewController!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModuleInteractor()
        postService = MockPostService()
        sut.postService = postService
        presenter = FeedModulePresenter()
        sut.output = presenter
        view = FeedModuleViewController()
        presenter.view = view
    }
    
    func testThatRecentFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.recent
        
        // when
        sut.fetchPosts(limit: 5, cursor: "cursor", feedType: feedType)
        
        // then
        XCTAssertTrue(postService.fetchRecentIsCalled)
        XCTAssertTrue(postService.fetchRecentQuery?.limit == 5)
        XCTAssertTrue(postService.fetchRecentQuery?.cursor == "cursor")
    }
    
    func testThatHomeFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.home
        
        // when
        sut.fetchPosts(limit: 5, cursor: "cursor", feedType: feedType)
        
        // then
        XCTAssertTrue(postService.fetchHomeIsCalled)
        XCTAssertTrue(postService.fetchHomeQuery?.limit == 5)
        XCTAssertTrue(postService.fetchHomeQuery?.cursor == "cursor")
    }
    
    
    func testThatPopularFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.popular(type: .today)
        
        // when
        sut.fetchPosts(limit: 5, cursor: "10", feedType: feedType)
        
        // then
        XCTAssertTrue(postService.fetchPopularIsCalled)
        XCTAssertTrue(postService.fetchPopularQuery?.timeRange == .today )
        XCTAssertTrue(postService.fetchPopularQuery?.cursor == 10)
        XCTAssertTrue(postService.fetchPopularQuery?.limit == 5)
    }
    
    func testThatSinglePostFetchFeedRequestIsValid() {
        
        // given
        let feedType = FeedType.single(post: "handle")
        
        // when
        sut.fetchPosts(feedType: feedType)
        
        // then
        XCTAssertTrue(postService.fetchPostHandle == "handle")
    }
    
    func testThatUserRecentFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.user(user: "user", scope: .recent)
        
        // when
        sut.fetchPosts(limit: 20, cursor: "cursor", feedType: feedType)
        
        // then
        XCTAssertTrue(postService.fetchRecentForUserIsCalled)
        XCTAssertTrue(postService.fetchRecentForUserQuery?.limit == 20)
        XCTAssertTrue(postService.fetchRecentForUserQuery?.user == "user")
        XCTAssertTrue(postService.fetchRecentForUserQuery?.cursor == "cursor")
    }
    
    func testThatUserPopularFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.user(user: "user", scope: .popular)
        
        // when
        sut.fetchPosts(limit: 20, cursor: "cursor", feedType: feedType)
        
        // then
        XCTAssertTrue(postService.fetchPopularForUserIsCalled)
        XCTAssertTrue(postService.fetchPopularForUserQuery?.limit == 20)
        XCTAssertTrue(postService.fetchPopularForUserQuery?.user == "user")
        XCTAssertTrue(postService.fetchPopularForUserQuery?.cursor == "cursor")
    }
    
    
}
