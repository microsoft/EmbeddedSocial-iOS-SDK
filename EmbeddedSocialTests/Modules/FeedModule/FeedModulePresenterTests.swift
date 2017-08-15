//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class FeedModuleViewMock: FeedModuleViewInput {
    
    var didSetRefreshingState = false
    var didSetIndex: Int?
    var didSetLayout: FeedModuleLayoutType?
    var didReloadTimes = 0
    var didReload = false
    
    func registerHeader<T: UICollectionReusableView>(withType type: T.Type, configurator: @escaping (T) -> Void) { }
    
    func setupInitialState( ) {
    
    }

    func setLayout(type: FeedModuleLayoutType) {
        didSetLayout = type
    }
    
    func reload() {
        didReload = true
        didReloadTimes += 1
    }

    func reload(with index: Int) {
        didSetIndex = index
    }
    
    func setRefreshing(state: Bool) {
        didSetRefreshingState = state
    }
    
    func getViewHeight() -> CGFloat {
        return 0
    }
    
    func reloadVisible() {
        
    }
    
    func removeItem(index: Int) {
        
    }
    
    func showError(error: Error) {
        
    }
}

private class FeedModuleRouterMock: FeedModuleRouterInput {
    
    var openedRoute: FeedModuleRoutes!
    
    func open(route: FeedModuleRoutes, feedSource:FeedType) {
        openedRoute = route
    }
    
}

private class FeedModuleInteractorMock: FeedModuleInteractorInput {

    var fetchedPosts = false
    var fetchedCursor: String?
    var fetchedLimit: Int32?
    var fetchedFeedType: FeedType!
    
    func fetchPosts(limit: Int32?, cursor: String?, feedType: FeedType) {
        fetchedPosts = true
        fetchedLimit = limit
        fetchedCursor = cursor
        fetchedFeedType = feedType
    }
    
    func postAction(post: PostHandle, action: PostSocialAction) { }
}

class FeedModulePresenter_Tests: XCTestCase {
    
    var sut: FeedModulePresenter!
    private var view: FeedModuleViewMock!
    private var interactor: FeedModuleInteractorMock!
    private var router: FeedModuleRouterMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModulePresenter()
        sut.setFeed(.home)
        
        view = FeedModuleViewMock()
        sut.view = view
        
        interactor = FeedModuleInteractorMock()
        sut.interactor = interactor
        
        router = FeedModuleRouterMock()
        sut.router = router
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
    
    func testThatViewHandlesEndOfFetching() {
        
        // given
        view.didSetRefreshingState = true
        
        // when
        sut.didFinishFetching()
        
        // then
        XCTAssertTrue(view.didSetRefreshingState == false)
    }
    
    func testThatViewHandlesStartOfFetching() {
        
        // given
        view.didSetRefreshingState = false
        
        // when
        sut.didStartFetching()
        
        // then
        XCTAssertTrue(view.didSetRefreshingState == true)
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
        XCTAssertTrue(view.didReload == true)
        XCTAssertTrue(view.didReloadTimes == 2)
    }
    
    func testThatOnFeedTypeChangeFetchIsDone() {
        
        // given
        let feedType = FeedType.single(post: "handle")
        sut.setFeed(feedType)
        
        // when
        sut.refreshData()
        
        // then
        XCTAssertTrue(interactor.fetchedFeedType == FeedType.single(post: "handle"))
        XCTAssertTrue(interactor.fetchedPosts)
    }
    
    func testThatFetchDataTriggersViewReload() {
        
        // given
        let feed = PostsFeed(items: [Post.mock(seed: 0)], cursor: "cursor")
        
        // when
        sut.didFetch(feed: feed)
        
        // then
        XCTAssertTrue(view.didReload == true)
    }
    
    func testThatLayoutChanges() {
        
        // given
        let layout = FeedModuleLayoutType.grid
        XCTAssertTrue(view.didSetLayout != layout)
        
        // when
        sut.layout = layout
        
        // then
        XCTAssertTrue(view.didSetLayout == layout)
    }
    
    func testThatProfileOpens() {
        
        // given
        var post = Post.mock(seed: 0)
        post.userHandle = "user"
        
        let feed = PostsFeed(items: [post], cursor: "cursor")
        sut.didFetch(feed: feed)
        let path = IndexPath(row: 0, section: 0)
        let action = PostCellAction.profile
        let item = sut.item(for: path)
        
        // when
        item.onAction!(action, path)
        
        // then
        if case FeedModuleRoutes.profileDetailes(user: "user" ) = router.openedRoute! {
            XCTAssert(true)
        } else {
            XCTAssert(false)
        }
    }

}
