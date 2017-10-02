//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class FeedModulePresenterMock: FeedModuleInteractorOutput {

    var startFetchingIsCalled = false
    var finishFetchingIsCalled = false

    var failedError: Error?
    var postedAction: (post: PostHandle, action: PostSocialAction, error: Error?)?
    var fetchedFeed: Feed?
    var fetchedMoreFeed: Feed?
    var startedFetching = false
    var finishedFetching = false
    
    func didFail(error: Error) {
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
    
    func didFetch(feed: Feed) {
        fetchedFeed = feed
    }
    
    func didFetchMore(feed: Feed) {
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
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: nil, limit: nil, feedType: .home)
        service.fetchHomeQueryCompletion = FeedFetchResult()
        
        // when
        sut.fetchPosts(request: request)
    
        // then
        XCTAssertTrue(presenter.startedFetching == true)
        XCTAssertTrue(presenter.finishedFetching == true)
    }
    
    func testThatFetchFeedFiresError() {
        
        // given
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: nil, limit: nil, feedType: .home)
        service.fetchHomeQueryCompletion = FeedFetchResult()
        service.fetchHomeQueryCompletion.error = FeedServiceError.failedToFetch(message: "Ooops")
        
        // when
        sut.fetchPosts(request: request)
    
        // then
        XCTAssert(presenter.failedError != nil)
    }
    
    func testThatFetchMoreGetsCalled() {
        
        // given
        let cursor = uniqueString()
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: cursor, limit: nil, feedType: .home)
        service.fetchHomeQueryCompletion = FeedFetchResult()
        
        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedMoreFeed != nil)
    }
    
    func testThatFetchHomeResultIsCorrect() {
        
        // given
        let cursor = uniqueString()
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: cursor, limit: nil, feedType: .home)
        service.fetchHomeQueryCompletion = FeedFetchResult()
        service.fetchHomeQueryCompletion.cursor = cursor
        service.fetchHomeQueryCompletion.posts = [Post.mock(seed: 0)]

        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.cursor == cursor)
        XCTAssertTrue(presenter.fetchedFeed?.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed?.items.last == Post.mock(seed: 0))
    }
    
    func testThatFetchRecentResultIsCorrect() {
        
        // given
        let cursor = uniqueString()
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: cursor, limit: nil, feedType: .home)
        service.fetchRecentQueryCompletion = FeedFetchResult()
        service.fetchRecentQueryCompletion.cursor = cursor
        service.fetchRecentQueryCompletion.posts = [Post.mock(seed: 0)]
        
        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.cursor == cursor)
        XCTAssertTrue(presenter.fetchedFeed?.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed?.items.last == Post.mock(seed: 0))
    }
    
    
    func testThatFetchPopularResultIsCorrect() {
        
        // given
        let cursor = uniqueString()
        let feed = FeedType.popular(type: FeedType.TimeRange.alltime)
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: cursor, limit: nil, feedType: feed)
        service.fetchPopularQueryCompletion = FeedFetchResult()
        service.fetchPopularQueryCompletion.cursor = cursor
        service.fetchPopularQueryCompletion.posts = [Post.mock(seed: 1)]
        
        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.cursor == cursor)
        XCTAssertTrue(presenter.fetchedFeed?.items.count == 1)
    }
    
    func testThatUserPopularFeedIsCorrect() {
        
        // given
        let user = uniqueString()
        let cursor = uniqueString()
        let feed = FeedType.user(user: user, scope: FeedType.UserFeedScope.popular)
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: cursor, limit: nil, feedType: feed)
        service.fetchUserPopularQueryCompletion = FeedFetchResult()
        service.fetchUserPopularQueryCompletion.cursor = cursor
        
        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.cursor == cursor)
    }
    
    func testThatUserRecentFeedIsCorrect() {
        
        // given
        let user = uniqueString()
        let cursor = uniqueString()
        let feed = FeedType.user(user: user, scope: FeedType.UserFeedScope.recent)
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: cursor, limit: nil, feedType: feed)
        service.fetchUserRecentQueryCompletion = FeedFetchResult()
        service.fetchUserRecentQueryCompletion.cursor = cursor
        
        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.cursor == cursor)
    }
    
    func testThatSinglePostFetchResultIsCorrect() {
        
        // given
        let handle = uniqueString()
        let feed = FeedType.single(post: handle)
        let request = FeedFetchRequest(uid: UUID().uuidString, cursor: nil, limit: nil, feedType: feed)
        service.fetchPostPostCompletion = FeedFetchResult()
        service.fetchPostPostCompletion.posts = [Post.mock(seed: 100)]
    
        // when
        sut.fetchPosts(request: request)
        
        // then
        XCTAssertTrue(presenter.fetchedFeed?.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed?.items.last == Post.mock(seed: 100))
    }
    
}
