//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class PostServiceMock: PostServiceProtocol {
    
    typealias Result = PostFetchResult
    
    var popularResult: Result!
    var userPopularResult: Result!
    var singlePostResult: Result!
    var userRecentResult: Result!
    var recentResult: Result!
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        completion(popularResult)
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        completion(recentResult)
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        completion(userRecentResult)
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        completion(userPopularResult)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        completion(singlePostResult)
    }
}

private class FeedModulePresenterMock: FeedModuleInteractorOutput {
  
    var startFetchingIsCalled = false
    var finishFetchingIsCalled = false
    
    private (set) var calls = [String:Bool]()
    var didFailError: FeedServiceError?
    var didPostAction: (post: PostHandle, action: PostSocialAction, error: Error?)?
    var didFetchFeed: PostsFeed?
    var didFetchMoreFeed: PostsFeed?
    
    func didFail(error: FeedServiceError) {
        didFailError = error
    }
    
    func didStartFetching() {
        calls[#function] = true
    }
    
    func didFinishFetching() {
        calls[#function] = true
    }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        didPostAction = (post, action, error)
    }
    
    func didFetch(feed: PostsFeed) {
        didFetchFeed = feed
    }
    
    func didFetchMore(feed: PostsFeed) {
        didFetchMoreFeed = feed
    }
}

class FeedModuleInteractor_Pagination_Tests: XCTestCase {
    
    var sut: FeedModuleInteractor!
    private var service: PostServiceMock!
    private var presenter: FeedModulePresenterMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModuleInteractor()
        service = PostServiceMock()
        sut.postService = service
        presenter = FeedModulePresenterMock()
        sut.output = presenter
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatFetchPostsFiresStartAndFinish() {
        
        // given
        let feed = FeedType.home
        service.recentResult = PostFetchResult()
        service.recentResult.error = nil
        
        // when
        sut.fetchPosts(feedType: feed)
    
        // then
        XCTAssertTrue(presenter.calls["didStartFetching()"] == true)
        XCTAssertTrue(presenter.calls["didFinishFetching()"] == true)
    }
    
    func testThatFetchFeedFiresError() {
        
        // given
        let feed = FeedType.home
        service.recentResult = PostFetchResult()
        service.recentResult.error = FeedServiceError.failedToFetch(message: "Ooops")
        
        // when
        sut.fetchPosts(feedType: feed)
    
        // then
        XCTAssert(presenter.didFailError != nil)
    }
    
    func testThatFetchMoreGetsCalled() {
        
        // given
        let feed = FeedType.home
        service.recentResult = PostFetchResult()
        
        // when
        sut.fetchPostsMore(feedType: feed, cursor: "cursor")
        
        // then
        XCTAssertTrue(presenter.didFetchMoreFeed != nil)
    }
    
    func testThatFetchHomeResultIsCorrect() {
        
        // given
        let feed = FeedType.home
        service.recentResult = PostFetchResult()
        service.recentResult.cursor = "--erwrw--"
        service.recentResult.posts = [Post.mock(seed: 0)]

        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.didFetchFeed!.cursor == "--erwrw--")
        XCTAssertTrue(presenter.didFetchFeed!.items.count == 1)
        XCTAssertTrue(presenter.didFetchFeed!.items.last! == Post.mock(seed: 0))
    }
    
    func testThatFetchPopularResultIsCorrect() {
        
        // given
        let feed = FeedType.popular(type: FeedType.TimeRange.alltime)
        service.popularResult = PostFetchResult()
        service.popularResult.cursor = "--fwew4ef--"
        service.popularResult.posts = [Post.mock(seed: 1)]
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.didFetchFeed!.cursor == "--fwew4ef--")
        XCTAssertTrue(presenter.didFetchFeed!.items.count == 1)
    }
    
    func testThatUserPopularFeedIsCorrect() {
        
        // given
        let feed = FeedType.user(user: "handle", scope: FeedType.UserFeedScope.popular)
        service.userPopularResult = PostFetchResult()
        service.userPopularResult.cursor = "user popular cursor"
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.didFetchFeed!.cursor == "user popular cursor")
    }
    
    func testThatUserRecentFeedIsCorrect() {
        
        // given
        let feed = FeedType.user(user: "handle", scope: FeedType.UserFeedScope.recent)
        service.userRecentResult = PostFetchResult()
        service.userRecentResult.cursor = "user recent cursor"
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.didFetchFeed!.cursor == "user recent cursor")
    }
    
    func testThatSinglePostFetchResultIsCorrect() {
        
        // given
        let feed = FeedType.single(post: "handle")
        service.singlePostResult = PostFetchResult()
        service.singlePostResult.posts = [Post.mock(seed: 100)]
    
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.didFetchFeed!.items.count == 1)
        XCTAssertTrue(presenter.didFetchFeed!.items.last == Post.mock(seed: 100))
    }
}
