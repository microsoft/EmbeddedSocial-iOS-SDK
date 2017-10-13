//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BaseTestHome: BaseFeedTest {
    
    var pageSize: Int!
    var serviceName: String!
    
    override func setUp() {
        super.setUp()
        
        pageSize = EmbeddedSocial.Constants.Feed.pageSize
        
        feedName = "topics"
        serviceName = "topics"
    }
    
    override func tearDown() {
        super.tearDown()
        
        APIConfig.numberedTopicTeasers = false
        APIConfig.showTopicImages = false
        APIConfig.showUserImages = false
    }
    
    override func openScreen() {}
    
    //Post titles and handles depend on feed source
    
    func testFeedSource() {
        let (index, post) = feed.getRandomPost()
        XCTAssert(post.textExists(feedName + String(index)), "Incorrect feed source")
    }
    
    func testPostAttributes() {
        let (_, post) = feed.getRandomPost()
        
        XCTAssert(post.textExists("John Doe"), "Author name doesn't match")
        XCTAssert(post.textExists("5 likes"), "Number of likes doesn't match")
        XCTAssert(post.textExists("7 comments"), "Number of comments doesn't match")
        XCTAssertEqual(post.teaser.value as! String, "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Teaser text doesn't match")
        XCTAssert(post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(post.pinButton.isSelected, "Post is not marked as pinned")
    }
    
    func testLikePost() {
        let (index, post) = feed.getRandomPost()
        
        post.like()
        checkIsLiked(post, at: index)
        
        post.like()
        checkIsDisliked(post, at: index)
    }
    
    func checkIsLiked(_ post: Post, at index: UInt) {
        XCTAssert(post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(post.textExists("1 like"), "Likes counter wasn't incremented")
    }
    
    func checkIsDisliked(_ post: Post, at index: UInt) {
        XCTAssert(!post.likeButton.isSelected, "Post is marked as liked")
        XCTAssert(post.textExists("0 likes"), "Likes counter wasn't decremented")
    }
    
    func testPinPostButton() {
        let (index, post) = feed.getRandomPost()
        
        post.pin()
        checkIsPinned(post, at: index)
        
        post.pin()
        checkIsUnpinned(post, at: index)
    }
    
    func checkIsPinned(_ post: Post, at index: UInt) {
        XCTAssert(post.pinButton.isSelected, "Post is not marked as pinned")
    }
    
    func checkIsUnpinned(_ post: Post, at index: UInt) {
        XCTAssert(!post.pinButton.isSelected, "Post is marked as pinned")
    }

    func testPaging() {
        var seenPosts = Set<XCUIElement>()
        var retryCount = 25
        
        while seenPosts.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...feed.getPostsCount() - 1 {
                let post = feed.getPost(i)
                seenPosts.insert(post.cell)
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenPosts.count, pageSize, "New posts weren't loaded while swiping feed up")
    }
    
    func testPullToRefresh() {
        for _ in 0...5 {
            app.swipeUp()
        }
        
        for _ in 0...5 {
            app.swipeDown()
        }
        
        let post = feed.getPost(0)
        let start = post.cell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = post.cell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        XCTAssertTrue(feed.getPostsCount() != 0)
    }
    
    func testPostImagesLoaded() {
        XCTAssertTrue(feed.getRandomPost().1.postImageButton.exists, "Post images weren't loaded")
    }

    func testOpenPostDetails() {
        let details = PostDetails(app)
        XCTAssertEqual(details.post.teaser.value as! String, "Post Details Screen", "Post details screen haven't been opened")
    }
    
    func testPagingTileMode() {
        var seenPosts = Set<XCUIElement>()
        var retryCount = 25
        
        while seenPosts.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...feed.getPostsCount() - 1 {
                let post = feed.getPost(i)
                seenPosts.insert(post.cell)
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenPosts.count, pageSize, "New posts weren't loaded while swiping feed up")
    }
    
    func testPostImagesLoadedTileMode() {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/images/"), "Post images weren't loaded")
    }
    
    func testPullToRefreshTileMode() {
        for _ in 0...5 {
            app.swipeUp()
        }
        
        for _ in 0...5 {
            app.swipeDown()
        }
        
        let post = feed.getPost(0)
        let start = post.cell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = post.cell.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        XCTAssertTrue(feed.getPostsCount() != 0)
    }
    
    func testOpenPostDetailsTileMode() {
        let details = PostDetails(app)
        XCTAssertEqual(details.post.teaser.value as! String, "Post Details Screen", "Post details screen haven't been opened")
    }
    
}

class TestOnlineHome: BaseTestHome, OnlineTest {
    
    override func testFeedSource() {
        openScreen()
        super.testFeedSource()
    }
    
    override func testPostAttributes() {
        APIConfig.values = ["user->firstName": "John",
                            "user->lastName": "Doe",
                            "totalLikes": 5,
                            "totalComments": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true,
                            "pinned": true]
        
        openScreen()
        super.testPostAttributes()
    }
    
    override func testLikePost() {
        openScreen()
        super.testLikePost()
    }
    
    override func checkIsLiked(_ post: Post, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains(feedName + String(index) + "/likes"))
        super.checkIsLiked(post, at: index)
    }
    
    override func checkIsDisliked(_ post: Post, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("topics" + String(index) + "/likes/me"))
        super.checkIsDisliked(post, at: index)
    }
    
    override func testPinPostButton() {
        openScreen()
        super.testPinPostButton()
    }
    
    override func checkIsPinned(_ post: Post, at index: UInt) {
        let request = APIState.getLatestData(forService: "pins")
        XCTAssertEqual(request?["topicHandle"] as! String, feedName + String(index))
        super.checkIsPinned(post, at: index)
    }
    
    override func checkIsUnpinned(_ post: Post, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/pins/\(feedName + String(index))"))
        super.checkIsUnpinned(post, at: index)
    }
    
    override func testPaging() {
        APIConfig.numberedTopicTeasers = true
        openScreen()
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        openScreen()
        
        super.testPullToRefresh()
        
        let response = APIState.getLatestResponse(forService: serviceName)
        XCTAssertNotNil(Int(response?["cursor"] as! String), "First page wasn't loaded on Pull to Refresh")
    }
    
    override func testPostImagesLoaded() {
        APIConfig.showTopicImages = true
        
        openScreen()
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"), "Post images weren't loaded")
        super.testPostImagesLoaded()
    }
    
    override func testOpenPostDetails() {
        openScreen()
        
        let (_, post) = feed.getRandomPost()
        APIConfig.values = ["text": "Post Details Screen"]
        post.teaser.tap()
        
        super.testOpenPostDetails()
    }
    
    override func testPagingTileMode() {
        openScreen()
        feed.switchViewMode()
        
        super.testPagingTileMode()
    }
    
    override func testPostImagesLoadedTileMode() {
        APIConfig.showTopicImages = true
        
        openScreen()
        feed.switchViewMode()
        
        super.testPostImagesLoadedTileMode()
    }
    
    override func testPullToRefreshTileMode() {
        openScreen()
        feed.switchViewMode()
        
        super.testPullToRefreshTileMode()
        
        let response = APIState.getLatestResponse(forService: serviceName)
        XCTAssertNotNil(Int(response?["cursor"] as! String), "First page wasn't loaded on Pull to Refresh")
    }
    
    override func testOpenPostDetailsTileMode() {
        openScreen()
        feed.switchViewMode()
        
        let (_, post) = feed.getRandomPost()
        APIConfig.values = ["text": "Post Details Screen"]
        post.cell.tap()
        
        super.testOpenPostDetailsTileMode()
    }
    
}

class TestOfflineHome: BaseTestHome, OfflineTest {
    
    override func testFeedSource() {
        openScreen()
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testFeedSource()
    }
    
    override func testPostAttributes() {
        APIConfig.values = ["user->firstName": "John",
                            "user->lastName": "Doe",
                            "totalLikes": 5,
                            "totalComments": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true,
                            "pinned": true]
        
        openScreen()
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testPostAttributes()
    }
    
    override func testLikePost() {
        openScreen()
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testLikePost()
    }
    
    override func testPinPostButton() {
        openScreen()
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testPinPostButton()
    }
    
    override func testPaging() {
        APIConfig.numberedTopicTeasers = true
        openScreen()
        
        // load next page in online
        super.testPaging()
        
        // scroll to up
        for _ in 1...7 {
            app.swipeDown()
        }
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        
        // test offline pagination
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        openScreen()
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testPullToRefresh()
    }
    
    override func testPostImagesLoaded() {
        APIConfig.showTopicImages = true
        
        openScreen()
        
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testPostImagesLoaded()
    }
    
    override func testOpenPostDetails() {
        openScreen()
        
        let (_, post) = feed.getRandomPost()
        APIConfig.values = ["text": "Post Details Screen"]
        post.teaser.tap()
        
        let details = PostDetails(app)
        makePullToRefreshWithoutReachability(with: details.post.cell)
        super.testOpenPostDetails()
    }
    
    override func testPagingTileMode() {
        openScreen()
        feed.switchViewMode()
        
        // load next page in online
        super.testPagingTileMode()
        
        // scroll to up
        for _ in 1...5 {
            app.swipeDown()
        }
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        
        // test offline pagination
        super.testPagingTileMode()
    }
    
    override func testPullToRefreshTileMode() {
        openScreen()
        feed.switchViewMode()
        
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testPullToRefreshTileMode()
    }
    
    override func testOpenPostDetailsTileMode() {
        openScreen()
        feed.switchViewMode()
        
        let (_, post) = feed.getRandomPost()
        APIConfig.values = ["text": "Post Details Screen"]
        post.cell.tap()
        
        makePullToRefreshWithoutReachability(with: feed.getPost(0).cell)
        super.testOpenPostDetailsTileMode()
    }
    
}
