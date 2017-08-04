//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestHome: UITestBase {
    var sideMenu: SideMenu!
    var feed: PostsFeed!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        feed = PostsFeed(app)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //Post titles and handles depend on feed source
    func testFeedSource() {
        sideMenu.navigateTo("Home")
        
        let (index, post) = feed.getRandomPost()
        
        XCTAssert(post.textExists("topics" + String(index)), "Incorrect feed source")
    }
    
    func testPostAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "totalComments": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true,
                            "pinned": true]
        
        sideMenu.navigateTo("Home")
        
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
        sideMenu.navigateTo("Home")
        
        let (index, post) = feed.getRandomPost()
        
        post.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("topics" + String(index) + "/likes"))
        XCTAssert(post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(post.textExists("1 like"), "Likes counter wasn't incremented")
        
        post.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("topics" + String(index) + "/likes/me"))
        XCTAssert(!post.likeButton.isSelected, "Post is marked as liked")
        XCTAssert(post.textExists("0 likes"), "Likes counter wasn't decremented")
    }
    
    
    func testPinPost() {
        sideMenu.navigateTo("Home")
        
        let (index, post) = feed.getRandomPost()
        
        post.pin()
        
        let request = APIState.getLatestData(forService: "pins")
        
        XCTAssertEqual(request?["topicHandle"] as! String, "topics" + String(index))
        XCTAssert(post.pinButton.isSelected, "Post is not marked as pinned")
        
        post.pin()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/pins/topics" + String(index)))
        XCTAssert(!post.pinButton.isSelected, "Post is marked as pinned")
        
    }
}
