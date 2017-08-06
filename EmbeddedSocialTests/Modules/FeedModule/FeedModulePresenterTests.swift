//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class FeedModuleViewMock: FeedModuleViewInput {
    
    var refreshingState = false
    var index: Int?
    var layout: FeedModuleLayoutType?
    var calls = [String:Bool]()
    var reloadedTimes = 0
    
    func setupInitialState( ) {
        calls[#function] = true
    }

    func setLayout(type: FeedModuleLayoutType) {
        calls[#function] = true
        layout = type
    }
    
    func reload() {
        calls[#function] = true
        reloadedTimes += 1
    }

    func reload(with index: Int) {
        calls[#function] = true
        self.index = index
    }
    
    func setRefreshing(state: Bool) {
        calls[#function] = true
        refreshingState = state
    }
    
    func getViewHeight() -> CGFloat {
        calls[#function] = true
        return 0
    }
}


private class FeedModuleInteractorMock: FeedModuleInteractorInput {

    var didFetchPosts = false
    var didFetchMorePosts = false
    var didFetchMoreWithCursor: String!
    var didFetchLimit: Int32?
    var didFetchFeedType: FeedType?
    
    func fetchPosts(limit: Int32?, feedType: FeedType) {
        didFetchPosts = true
        didFetchLimit = limit
        didFetchFeedType = feedType
    }
    
    func fetchPostsMore(limit: Int32?, feedType: FeedType, cursor: String) {
        didFetchMorePosts = true
        didFetchLimit = limit
        didFetchFeedType = feedType
        didFetchMoreWithCursor = cursor
    }
    
    func postAction(post: PostHandle, action: PostSocialAction) { }
}

class FeedModulePresenterTests: XCTestCase {
    
    var sut: FeedModulePresenter!
    private var view: FeedModuleViewMock!
    private var interactor: FeedModuleInteractorMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModulePresenter()
        sut.setFeed(.home)
        
        view = FeedModuleViewMock()
        sut.view = view
        
        interactor = FeedModuleInteractorMock()
        sut.interactor = interactor
    }
    
    func testThatViewModelIsCorrect() {
        
        // given
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.day = -2
        
        let creationDate = calendar.date(byAdding: comps, to: Date())
        
        var post = Post()
        
        post.firstName = "vasiliy"
        post.lastName = "bodia"
        post.pinned = false
        post.liked = true
        post.title = "post 1 mocked"
        post.totalLikes = 1
        post.totalComments = 2
        post.createdTime = creationDate
        
        let posts = [post]
        let feed = PostsFeed(items: posts, cursor: nil)
        sut.didFetch(feed: feed)
        let path = IndexPath(row: 0, section: 0)
        
        // when
        let viewModel = sut.item(for: path)
        
        // then
        XCTAssertTrue(viewModel.isLiked == true)
        XCTAssertTrue(viewModel.isPinned == false)
        XCTAssertTrue(viewModel.userName == "vasiliy bodia")
        XCTAssertTrue(viewModel.totalLikes == "1 like")
        XCTAssertTrue(viewModel.totalComments == "2 comments")
        XCTAssertTrue(viewModel.timeCreated == "2d")
    }
    
//    func didFetch(feed: PostsFeed)
//    func didFetchMore(feed: PostsFeed)
//    func didFail(error: FeedServiceError)
//    func didStartFetching()
//    func didFinishFetching()
//
//    func didPostAction(post: PostHandle, action: PostSocialAction, error: Error?)
    
    
//    func viewIsReady()
//
//    func numberOfItems() -> Int
//    func item(for path: IndexPath) -> PostViewModel
//
//    func didTapChangeLayout()
//    func didTapItem(path: IndexPath)
//
//    func didAskFetchAll()
//    func didAskFetchMore()
    
    
    
    
    ///
    
    
    
    
    
    func testThatViewHandlesEndOfFetching() {
        
        // given
        view.refreshingState = true
        
        // when
        sut.didFinishFetching()
        
        // then
        XCTAssertTrue(view.refreshingState == false)
    }
    
    func testThatViewHandlesStartOfFetching() {
        
        // given
        view.refreshingState = false
        
        // when
        sut.didStartFetching()
        
        // then
        XCTAssertTrue(view.refreshingState == true)
    }
    
    func testThatFetchFeedProducesCorrectItems() {
        
        // given
        let initialPost = Post.mock(seed: 10)
        let initialFeed = PostsFeed(items: [initialPost], cursor: nil)
        
        // when
        sut.didFetch(feed: initialFeed)
        
        // then
        XCTAssertTrue(sut.item(for: IndexPath(row: 0, section: 0)).title == "Title 10")
        XCTAssertTrue(sut.numberOfItems() == 1)
    }
    
    func testThatReFetchFeedProducesCorrectItems() {
        
        // given
        let path = IndexPath(row: 0, section: 0)
        
        let postsA = [Post.mock(seed: 1), Post.mock(seed: 2)]
        let feedA = PostsFeed(items: postsA, cursor: nil)
        sut.didFetch(feed: feedA)
        
        let postsB = [Post.mock(seed: 3), Post.mock(seed: 4), Post.mock(seed: 5)]
        let feedB = PostsFeed(items: postsB, cursor: nil)
        
        // when
        sut.didFetch(feed: feedB)
        
        // then
        XCTAssert(sut.numberOfItems() == 3)
        XCTAssertTrue(sut.item(for: path).title == "Title 3")
    }
    
    
    func testThatFetchMoreHandlesFeedCorrectly() {
        
        // given
        let initialPost = Post.mock(seed: 1)
        let initialFeed = PostsFeed(items: [initialPost], cursor: nil)
        sut.didFetch(feed: initialFeed)
        
        let morePosts = [Post.mock(seed: 2), Post.mock(seed: 3)]
        let moreFeed = PostsFeed(items: morePosts, cursor: "cursor")
        
        // when
        sut.didFetchMore(feed: moreFeed)
        
        // then
        XCTAssertTrue(sut.item(for: IndexPath(row: 0, section: 0)).title == "Title 1")
        XCTAssertTrue(sut.item(for: IndexPath(row: 1, section: 0)).title == "Title 2")
        XCTAssertTrue(sut.numberOfItems() == 3)
        XCTAssertTrue(view.calls["reload()"] == true)
        XCTAssertTrue(view.reloadedTimes == 2)
    }
    
    func testThatOnFeedTypeChangeFetchIsDone() {
        
        // given
        let feedType = FeedType.single(post: "handle")
        sut.setFeed(feedType)
        
        // when
        sut.refreshData()
        
        // then
        XCTAssertTrue(interactor.didFetchPosts)
    }
    
//    func test
    

}
