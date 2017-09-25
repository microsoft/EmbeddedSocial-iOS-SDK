//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class TestHome: UITestBase {
    var sideMenu: SideMenu!
    var feed: Feed!
    var details: PostDetails!
    var pageSize: Int!
    var feedName: String!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        feed = Feed(app)
        details = PostDetails(app)
        pageSize = EmbeddedSocial.Constants.Feed.pageSize
        feedName = "topics"
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.numberedTopicTeasers = false
        APIConfig.showTopicImages = false
    }
    
    
    func openScreen() {
        sideMenu.navigateTo("Popular")
        sideMenu.navigateTo("Home")
    }
    
    //Post titles and handles depend on feed source
    func testFeedSource() {
        openScreen()

        let (index, post) = feed.getRandomPost()
        
        XCTAssert(post.textExists(feedName + String(index)), "Incorrect feed source")
    }
    
    func testPostAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "totalComments": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true,
                            "pinned": true]
        
        openScreen()
        
        let (_, post) = feed.getRandomPost()
        
        XCTAssert(post.textExists("0s"), "Posted time doesn't match")
        XCTAssert(post.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssert(post.textExists("5 likes"), "Number of likes doesn't match")
        XCTAssert(post.textExists("7 comments"), "Number of comments doesn't match")
        XCTAssertEqual(post.teaser.value as! String, "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Teaser text doesn't match")
        XCTAssert(post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(post.pinButton.isSelected, "Post is not marked as pinned")

    }
    
    func testLikePost() {
        openScreen()
        
        let (index, post) = feed.getRandomPost()
        
        post.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains(feedName + String(index) + "/likes"))
        XCTAssert(post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(post.textExists("1 like"), "Likes counter wasn't incremented")
        
        post.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("topics" + String(index) + "/likes/me"))
        XCTAssert(!post.likeButton.isSelected, "Post is marked as liked")
        XCTAssert(post.textExists("0 likes"), "Likes counter wasn't decremented")
    }
    
    
    func testPinPost() {
        openScreen()
        
        let (index, post) = feed.getRandomPost()
        
        post.pin()
        
        let request = APIState.getLatestData(forService: "pins")
        
        XCTAssertEqual(request?["topicHandle"] as! String, feedName + String(index))
        XCTAssert(post.pinButton.isSelected, "Post is not marked as pinned")
        
        post.pin()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/pins/topics" + String(index)))
        XCTAssert(!post.pinButton.isSelected, "Post is marked as pinned")
    }
    
    func testPaging() {
        APIConfig.numberedTopicTeasers = true
        
        openScreen()
        
        var seenPosts = Set<String>()
        var retryCount = 25
        
        
        while seenPosts.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...feed.getPostsCount() - 1 {
                let post = feed.getPost(i)
                seenPosts.insert(post.teaser.value as! String)
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenPosts.count, pageSize, "New posts weren't loaded while swiping feed up")
    }
    
    func testPullToRefresh() {
        openScreen()
        
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
        
        let response = APIState.getLatestResponse(forService: "topics")

        XCTAssertEqual(Int(response?["cursor"] as! String), pageSize, "First page wasn't loaded on Pull to Refresh")
    }
    
    
    func testPostImagesLoaded() {
        APIConfig.showTopicImages = true
        
        openScreen()
        
        sleep(2) //Wait until images loaded
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/images/"), "Post images weren't loaded")
    }
    
    func testOpenPostDetails() {
        openScreen()
        
        APIConfig.values = ["text": "Post Details Screen"]
        
        let (_, post) = feed.getRandomPost()
        
        post.teaser.tap()
        
        XCTAssertEqual(details.post.teaser.value as! String, "Post Details Screen", "Post details screen haven't been opened")
    }
    
    func testPagingTileMode() {
        APIConfig.numberedTopicTeasers = true
        
        openScreen()
        
        feed.switchViewMode()
        
        var retryCount = 25
        var response = APIState.getLatestResponse(forService: "topics")
        
        while Int(response?["cursor"] as! String)! <= pageSize && retryCount != 0 {
            retryCount -= 1
            response = APIState.getLatestResponse(forService: "topics")
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(Int(response?["cursor"] as! String)!, pageSize, "New posts weren't loaded while swiping feed up")
    }
    
    func testPostImagesLoadedTileMode() {
        APIConfig.showTopicImages = true
        
        openScreen()
        
        feed.switchViewMode()
        
        sleep(2)
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/images/"), "Post images weren't loaded")
    }
    
    func testPullToRefreshTileMode() {
        openScreen()
        
        feed.switchViewMode()
        
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
        
        let response = APIState.getLatestResponse(forService: "topics")
        XCTAssertGreaterThanOrEqual(Int(response?["cursor"] as! String)!, pageSize, "Pages weren't loaded on Pull to Refresh")
    }
    
    func testOpenPostDetailsTileMode() {
        openScreen()
        
        feed.switchViewMode()
        
        APIConfig.values = ["text": "Post Details Screen"]
        
        let (_, post) = feed.getRandomPost()
        
        post.cell.tap()
        
        XCTAssertEqual(details.post.teaser.value as! String, "Post Details Screen", "Post details screen haven't been opened")
    }
}
