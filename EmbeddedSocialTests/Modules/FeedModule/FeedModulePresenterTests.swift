//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial


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
    var view: FeedModuleViewInput!
    private var interactor: FeedModuleInteractorMock!
    
    override func setUp() {
        super.setUp()
        
        sut = FeedModulePresenter()
        sut.setFeed(.home)
        
        view = FeedModuleViewController()
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
    
    func testThatOnFeedTypeChangeFetchingAllIsCalled() {
        
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
