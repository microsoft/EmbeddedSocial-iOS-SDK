//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class PostServiceMock: PostServiceProtocol {
    
    var popularResult: PostFetchResult!
    var userPopularResult: PostFetchResult!
    var singlePostResult: PostFetchResult!
    var userRecentResult: PostFetchResult!
    var recentResult: PostFetchResult!
    var homeResult: PostFetchResult!
    
    func fetchHome(query: HomeFeedQuery, completion: @escaping FetchResultHandler) {
        completion(homeResult)
    }
    
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
    
    func fetchMyPosts(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        
    }
    
    func fetchMyPopular(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        
    }
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) {
        
    }
}

private class FeedModulePresenterMock: FeedModuleInteractorOutput {
  
    var startFetchingIsCalled = false
    var finishFetchingIsCalled = false

    var failedError: FeedServiceError?
    var postedAction: (post: PostHandle, action: PostSocialAction, error: Error?)?
    var fetchedFeed: PostsFeed?
    var fetchedMoreFeed: PostsFeed?
    var startedFetching = false
    var finishedFetching = false
    
    func didFail(error: FeedServiceError) {
        failedError = error
    }
    
    func didStartFetching() {
        startedFetching = true
    }
    
    func didFinishFetching() {
        finishedFetching = true
    }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        postedAction = (post, action, error)
    }
    
    func didFetch(feed: PostsFeed) {
        fetchedFeed = feed
    }
    
    func didFetchMore(feed: PostsFeed) {
        fetchedMoreFeed = feed
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
        
        sut.userHolder = nil
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatFetchPostsFiresStartAndFinish() {
        
        // given
        let feed = FeedType.home
        service.homeResult = PostFetchResult()
        service.homeResult.error = nil
        
        // when
        sut.fetchPosts(feedType: feed)
    
        // then
        XCTAssertTrue(presenter.startedFetching == true)
        XCTAssertTrue(presenter.finishedFetching == true)
    }
    
    func testThatFetchFeedFiresError() {
        
        // given
        let feed = FeedType.home
        service.homeResult = PostFetchResult()
        service.homeResult.error = FeedServiceError.failedToFetch(message: "Ooops")
        
        // when
        sut.fetchPosts(feedType: feed)
    
        // then
        XCTAssert(presenter.failedError != nil)
    }
    
    func testThatFetchMoreGetsCalled() {
        
        // given
        let feed = FeedType.home
        service.homeResult = PostFetchResult()
        
        // when
        sut.fetchPosts(cursor: "cursor", feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedMoreFeed != nil)
    }
    
    func testThatFetchHomeResultIsCorrect() {
        
        // given
        let feed = FeedType.home
        service.homeResult = PostFetchResult()
        service.homeResult.cursor = "--erwrw--"
        service.homeResult.posts = [Post.mock(seed: 0)]

        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == "--erwrw--")
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed!.items.last! == Post.mock(seed: 0))
    }
    
    func testThatFetchRecentResultIsCorrect() {
        
        // given
        let feed = FeedType.recent
        service.recentResult = PostFetchResult()
        service.recentResult.cursor = "--erwrw--"
        service.recentResult.posts = [Post.mock(seed: 0)]
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == "--erwrw--")
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed!.items.last! == Post.mock(seed: 0))
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
        XCTAssertTrue(presenter.fetchedFeed!.cursor == "--fwew4ef--")
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
    }
    
    func testThatUserPopularFeedIsCorrect() {
        
        // given
        let feed = FeedType.user(user: "handle", scope: FeedType.UserFeedScope.popular)
        service.userPopularResult = PostFetchResult()
        service.userPopularResult.cursor = "user popular cursor"
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == "user popular cursor")
    }
    
    func testThatUserRecentFeedIsCorrect() {
        
        // given
        let feed = FeedType.user(user: "handle", scope: FeedType.UserFeedScope.recent)
        service.userRecentResult = PostFetchResult()
        service.userRecentResult.cursor = "user recent cursor"
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == "user recent cursor")
    }
    
    func testThatSinglePostFetchResultIsCorrect() {
        
        // given
        let feed = FeedType.single(post: "handle")
        service.singlePostResult = PostFetchResult()
        service.singlePostResult.posts = [Post.mock(seed: 100)]
    
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed!.items.last == Post.mock(seed: 100))
    }
}
