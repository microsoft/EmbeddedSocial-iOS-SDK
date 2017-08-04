//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class PostServiceMock: PostServiceProtocol {
    
    var popularResult: PostFetchResult!
    var mockedResult: PostFetchResult!
    
    func fetchPopular(query: PopularFeedQuery, completion: @escaping FetchResultHandler) {
        completion(mockedResult)
    }
    
    func fetchRecent(query: RecentFeedQuery, completion: @escaping FetchResultHandler) {
        completion(mockedResult)
    }
    
    func fetchRecent(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        completion(mockedResult)
    }
    
    func fetchPopular(query: UserFeedQuery, completion: @escaping FetchResultHandler) {
        completion(mockedResult)
    }
    
    func fetchPost(post: PostHandle, completion: @escaping FetchResultHandler) {
        completion(mockedResult)
    }
    
}

private class FeedModulePresenterMock: FeedModuleInteractorOutput {
  
    var startFetchingIsCalled = false
    var finishFetchingIsCalled = false
    var calls = [String:Bool]()
    
    func didFail(error: FeedServiceError) {
        calls[#function] = true
    }
    
    func didStartFetching() { calls[#function] = true }
    
    func didFinishFetching() { calls[#function] = true }
    
    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?) {
        calls[#function] = true
    }
    
    var fetchedFeed: PostsFeed!
    var error: FeedServiceError!
    
    func didFetch(feed: PostsFeed) {
        fetchedFeed = feed
        calls[#function] = true
    }
    
    func didFetchMore(feed: PostsFeed) {
        fetchedFeed = feed
        calls[#function] = true
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
    
    func testSinglePostFetchResultIsCorrect() {
        // given
        let expectedPost = Post.mock(seed: 100)
        var expectedResult = PostFetchResult()
        expectedResult.cursor = nil
        expectedResult.error = nil
        expectedResult.posts = [expectedPost]
        
//        service.mockedResult = mockedResult
    
        // when
        sut.fetchPosts(limit: 1, feedType: .single(post: "handle"))
        
        // then
        XCTAssertTrue(presenter.fetchedFeed.items.count == 1)
        XCTAssertTrue(presenter.fetchedFeed.items.last == expectedPost)
    }
    
//    func testSinglePostFetchResultIsCorrect2() {
//
//        // given
//        let expectedPost = Post.mock(seed: 100)
//        var mockedResult = PostFetchResult()
//        mockedResult.cursor = nil
//        mockedResult.error = nil
//        mockedResult.posts = [expectedPost]
//
//        input.mockedResult = mockedResult
//
//        // when
//        sut.fetchPosts(limit: 1, feedType: .single(post: "handle"))
//
//
//        // then
//        XCTAssertTrue(output.fetchedFeed.items.count == 1)
//        XCTAssertTrue(output.fetchedFeed.items.last == expectedPost)
//    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
