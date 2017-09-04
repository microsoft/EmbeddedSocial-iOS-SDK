//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

private class PostServiceMock: PostServiceProtocol {
    
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
    
    var fetchedMyPostsQuery: MyFeedQuery?
    var fetchedMyPopularQuery: MyFeedQuery?
    
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
        fetchedMyPostsQuery = query
    }
    
    func fetchMyPopular(query: MyFeedQuery, completion: @escaping FetchResultHandler) {
        fetchedMyPopularQuery = query
    }
    
    func fetchMyPins(query: MyPinsFeedQuery, completion: @escaping FetchResultHandler) {
        
    }
}

extension PostServiceMock {
    
    func deletePost(post: PostHandle, completion: @escaping ((Result<Void>) -> Void)) { }

}

class FeedModuleInteractor_FetchQuery_Tests: XCTestCase {
    
    var sut: FeedModuleInteractor!
    private var postService: PostServiceMock!
    var presenter: FeedModulePresenter!
    var view: FeedModuleViewController!
    var collectionView: UICollectionView!
    private var userHolder: UserHolderMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModuleInteractor()
            
        userHolder = UserHolderMock()
            
        sut.userHolder = userHolder
            
        postService = PostServiceMock()
        sut.postService = postService
        presenter = FeedModulePresenter()
        sut.output = presenter
        view = FeedModuleViewController()
        
        collectionView = UICollectionView(frame: CGRect.zero,
                                          collectionViewLayout: UICollectionViewFlowLayout.init())
        view.collectionView = collectionView
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
    
    func testThatMyPopularRequestIsCalled() {
        
        // given
        let limit = Int32(5)
        let cursor = UUID().uuidString
        let myUserHandle = UUID().uuidString
        let scope = FeedType.UserFeedScope.popular
        let feed = FeedType.user(user: myUserHandle, scope: scope)
        sut.userHolder!.me!.uid = myUserHandle
        
        // when
        sut.fetchPosts(limit: limit, cursor: cursor, feedType: feed)
        
        // then
        XCTAssertNotNil(postService.fetchedMyPopularQuery)
        XCTAssert(postService.fetchedMyPopularQuery?.cursor == cursor)
        XCTAssert(postService.fetchedMyPopularQuery?.limit == limit)
    }
    
    func testThatMyPostsRequestIsCalled() {
        
        // given
        let limit = Int32(5)
        let cursor = UUID().uuidString
        let myUserHandle = UUID().uuidString
        let scope = FeedType.UserFeedScope.recent
        let feed = FeedType.user(user: myUserHandle, scope: scope)
        sut.userHolder!.me!.uid = myUserHandle
        
        // when
        sut.fetchPosts(limit: limit, cursor: cursor, feedType: feed)
        
        // then
        XCTAssertNotNil(postService.fetchedMyPostsQuery)
        XCTAssert(postService.fetchedMyPostsQuery?.cursor == cursor)
        XCTAssert(postService.fetchedMyPostsQuery?.limit == limit)
    }

}
