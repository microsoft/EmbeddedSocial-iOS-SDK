//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class MockPostService: PostServiceProtocol {
    
    var result: PostFetchResult!
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        completion(result)
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        completion(result)
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        completion(result)
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        completion(result)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        completion(result)
    }
    
}

private class MockPresenter: FeedModuleInteractorOutput {
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        
    }
    
    var fetchedFeed: PostsFeed!
    var error: FeedServiceError!
    
    func didFetch(feed: PostsFeed) {
        fetchedFeed = feed
    }
    
    func didFetchMore(feed: PostsFeed) {
        fetchedFeed = feed
    }
    
    func didFail(error: FeedServiceError) { }
    
    func didLike(post id: PostHandle) { }
    
    func didUnlike(post id: PostHandle) { }
    
    func didUnpin(post id: PostHandle) { }
    
    func didPin(post id: PostHandle) { }
    
}

class FeedModuleInteractor_Pagination_Tests: XCTestCase {
    
    var sut: FeedModuleInteractor!
    private var input: MockPostService!
    private var output: MockPresenter!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModuleInteractor()
        input = MockPostService()
        sut.postService = input
        output = MockPresenter()
        sut.output = output
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPostsAreEqual() {
        
        let a = Post.mock(seed: 100)
        let b = Post.mock(seed: 100)
        
        XCTAssertTrue(a == b)
    }
    
    func testPostsAreNotEqual() {
        
        let a = Post.mock(seed: 100)
        let b = Post.mock(seed: 101)
        
        XCTAssertTrue(a != b)
    }
    
    func testSinglePostFetchResultIsCorrect() {
        // given
        let expectedPost = Post.mock(seed: 100)
        var expectedResult = PostFetchResult()
        expectedResult.cursor = nil
        expectedResult.error = nil
        expectedResult.posts = [expectedPost]
        
        input.result = expectedResult
    
        // when
        sut.fetchPosts(limit: 23, feedType: .single(post: "handle"))
        
        // then
        XCTAssertTrue(output.fetchedFeed.items.count == 1)
        XCTAssertTrue(output.fetchedFeed.items.last == expectedPost)
    }
    
    func testSinglePostFetchResultIsCorrect2() {
        
        // given
        let expectedPost = Post.mock(seed: 100)
        var expectedResult = PostFetchResult()
        expectedResult.cursor = nil
        expectedResult.error = nil
        expectedResult.posts = [expectedPost]
        
        input.result = expectedResult
        
        // when
        sut.fetchPosts(limit: 23, feedType: .single(post: "handle"))
        
        
        // then
        XCTAssertTrue(output.fetchedFeed.items.count == 1)
        XCTAssertTrue(output.fetchedFeed.items.last == expectedPost)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
