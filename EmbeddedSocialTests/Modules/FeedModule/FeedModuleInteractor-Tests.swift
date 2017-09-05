//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

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

class FeedModuleInteractor_Tests: XCTestCase {
    
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
        service.fetchHomeQueryCompletion = PostFetchResult()
        
        // when
        sut.fetchPosts(feedType: feed)
    
        // then
        XCTAssertTrue(presenter.startedFetching == true)
        XCTAssertTrue(presenter.finishedFetching == true)
    }
    
    func testThatFetchFeedFiresError() {
        
        // given
        let feed = FeedType.home
        service.fetchHomeQueryCompletion = PostFetchResult()
        service.fetchHomeQueryCompletion.error = FeedServiceError.failedToFetch(message: "Ooops")
        
        // when
        sut.fetchPosts(feedType: feed)
    
        // then
        XCTAssert(presenter.failedError != nil)
    }
    
    func testThatFetchMoreGetsCalled() {
        
        // given
        let cursor = uniqueString()
        let feed = FeedType.home
        service.fetchHomeQueryCompletion = PostFetchResult()
        
        // when
        sut.fetchPosts(cursor: cursor, feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedMoreFeed != nil)
    }
    
    func testThatFetchHomeResultIsCorrect() {
        
        // given
        let feed = FeedType.home
        let cursor = uniqueString()
        service.fetchHomeQueryCompletion = PostFetchResult()
        service.fetchHomeQueryCompletion.cursor = cursor
        service.fetchHomeQueryCompletion.posts = [Post.mock(seed: 0)]

        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == cursor)
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed!.items.last! == Post.mock(seed: 0))
    }
    
    func testThatFetchRecentResultIsCorrect() {
        
        // given
        let cursor = uniqueString()
        let feed = FeedType.recent
        service.fetchRecentQueryCompletion = PostFetchResult()
        service.fetchRecentQueryCompletion.cursor = cursor
        service.fetchRecentQueryCompletion.posts = [Post.mock(seed: 0)]
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == cursor)
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed!.items.last! == Post.mock(seed: 0))
    }
    
    
    func testThatFetchPopularResultIsCorrect() {
        
        // given
        let cursor = uniqueString()
        let feed = FeedType.popular(type: FeedType.TimeRange.alltime)
        service.fetchPopularQueryCompletion = PostFetchResult()
        service.fetchPopularQueryCompletion.cursor = cursor
        service.fetchPopularQueryCompletion.posts = [Post.mock(seed: 1)]
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == cursor)
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
    }
    
    func testThatUserPopularFeedIsCorrect() {
        
        // given
        let user = uniqueString()
        let cursor = uniqueString()
        let feed = FeedType.user(user: user, scope: FeedType.UserFeedScope.popular)
        service.fetchUserPopularQueryCompletion = PostFetchResult()
        service.fetchUserPopularQueryCompletion.cursor = cursor
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.cursor == cursor)
    }
    
    func testThatUserRecentFeedIsCorrect() {
        
        // given
        let user = uniqueString()
        let cursor = uniqueString()
        let feed = FeedType.user(user: user, scope: FeedType.UserFeedScope.recent)
        service.fetchUserRecentQueryCompletion = PostFetchResult()
        service.fetchUserRecentQueryCompletion.cursor = cursor
        
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.cursor == cursor)
    }
    
    func testThatSinglePostFetchResultIsCorrect() {
        
        // given
        let handle = uniqueString()
        let feed = FeedType.single(post: handle)
        service.fetchPostPostCompletion = PostFetchResult()
        service.fetchPostPostCompletion.posts = [Post.mock(seed: 100)]
    
        // when
        sut.fetchPosts(feedType: feed)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed!.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed!.items.last == Post.mock(seed: 100))
    }
    
}
