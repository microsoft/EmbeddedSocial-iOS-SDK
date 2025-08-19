//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

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
        let limit = Int32(5)
        let cursor = uniqueString()
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feedType)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchRecentQueryCompletionCalled)
        XCTAssertTrue(postService.fetchRecentQueryCompletionReceivedArguments?.query.limit == limit)
        XCTAssertTrue(postService.fetchRecentQueryCompletionReceivedArguments?.query.cursor == cursor)
    }
    
    func testThatHomeFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.home
        let cursor = uniqueString()
        let limit = Int32(5)
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feedType)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchHomeQueryCompletionCalled)
        XCTAssertTrue(postService.fetchHomeQueryCompletionReceivedArguments?.query.limit == limit)
        XCTAssertTrue(postService.fetchHomeQueryCompletionReceivedArguments?.query.cursor == cursor)
    }
    
    
    func testThatPopularFeedFetchRequestIsValid() {
        
        // given
        let feedType = FeedType.popular(type: .today)
        let cursor = uniqueString()
        let limit = Int32(5)
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feedType)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchPopularQueryCompletionCalled)
        XCTAssertTrue(postService.fetchPopularQueryCompletionReceivedArguments?.query.timeRange == .today )
        XCTAssertTrue(postService.fetchPopularQueryCompletionReceivedArguments?.query.cursor == cursor)
        XCTAssertTrue(postService.fetchPopularQueryCompletionReceivedArguments?.query.limit == limit)
    }
    
    func testThatSinglePostFetchFeedRequestIsValid() {
        
        // given
        let handle = uniqueString()
        let feedType = FeedType.single(post: handle)
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: nil,
                                            limit: 10,
                                            feedType: feedType)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchPostPostCompletionReceivedArguments?.post == handle)
    }
    
    func testThatUserRecentFeedFetchRequestIsValid() {
        
        // given
        let user = uniqueString()
        let feedType = FeedType.user(user: user, scope: .recent)
        let cursor = uniqueString()
        let limit = Int32(20)
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feedType)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchUserRecentQueryCompletionCalled)
        XCTAssertTrue(postService.fetchUserRecentQueryCompletionReceivedArguments?.query.limit == limit)
        XCTAssertTrue(postService.fetchUserRecentQueryCompletionReceivedArguments?.query.user == user)
        XCTAssertTrue(postService.fetchUserRecentQueryCompletionReceivedArguments?.query.cursor == cursor)
    }
    
    func testThatUserPopularFeedFetchRequestIsValid() {
        
        // given
        
        let cursor = uniqueString()
        let user = uniqueString()
        let limit = Int32(20)
        let feedType = FeedType.user(user: user, scope: .popular)
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feedType)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchUserPopularQueryCompletionCalled)
        XCTAssertTrue(postService.fetchUserPopularQueryCompletionReceivedArguments?.query.limit == limit)
        XCTAssertTrue(postService.fetchUserPopularQueryCompletionReceivedArguments?.query.user == user)
        XCTAssertTrue(postService.fetchUserPopularQueryCompletionReceivedArguments?.query.cursor == cursor)
    }
    
    func testThatMyPopularRequestIsCalled() {
        
        // given
        let limit = Int32(5)
        let cursor = UUID().uuidString
        let myUserHandle = UUID().uuidString
        let scope = FeedType.UserFeedScope.popular
        let feed = FeedType.user(user: myUserHandle, scope: scope)
        sut.userHolder!.me!.uid = myUserHandle
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feed)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssert(postService.fetchMyPopularQueryCompletionCalled)
        XCTAssert(postService.fetchMyPopularQueryCompletionReceivedArguments?.query.cursor == cursor)
        XCTAssert(postService.fetchMyPopularQueryCompletionReceivedArguments?.query.limit == limit)
    }
    
    func testThatMyPostsRequestIsCalled() {
        
        // given
        let limit = Int32(5)
        let cursor = UUID().uuidString
        let myUserHandle = UUID().uuidString
        let scope = FeedType.UserFeedScope.recent
        let feed = FeedType.user(user: myUserHandle, scope: scope)
        sut.userHolder!.me!.uid = myUserHandle
        
        let fetchRequest = FeedFetchRequest(uid: uniqueString(),
                                            cursor: cursor,
                                            limit: limit,
                                            feedType: feed)
        
        // when
        sut.fetchPosts(request: fetchRequest)
        
        // then
        XCTAssertTrue(postService.fetchMyPostsQueryCompletionCalled)
        XCTAssert(postService.fetchMyPostsQueryCompletionReceivedArguments?.query.cursor == cursor)
        XCTAssert(postService.fetchMyPostsQueryCompletionReceivedArguments?.query.limit == limit)
    }

}
