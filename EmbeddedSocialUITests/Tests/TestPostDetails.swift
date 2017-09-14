//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestPostDetails: UITestBase {
    var sideMenu: SideMenu!
    var feed: Feed!
    var details: PostDetails!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        feed = Feed(app)
        details = PostDetails(app)
    }
    
    func openScreen() {
        sideMenu.navigateTo("Home")
        let (_, post) = feed.getRandomPost()
        post.teaser.tap()
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
        
//        XCTAssert(details.post.textExists("1m"), "Posted time doesn't match")
        XCTAssert(details.post.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssert(details.post.textExists("5 likes"), "Number of likes doesn't match")
        XCTAssert(details.post.textExists("7 comments"), "Number of comments doesn't match")
        XCTAssertEqual(details.post.teaser.value as! String, "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", "Teaser text doesn't match")
        XCTAssert(details.post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(details.post.pinButton.isSelected, "Post is not marked as pinned")
        
    }
    
    func testLikePost() {
        openScreen()
        
        details.post.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
        XCTAssert(details.post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(details.post.textExists("1 like"), "Likes counter wasn't incremented")
        
        details.post.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
        XCTAssert(!details.post.likeButton.isSelected, "Post is marked as liked")
        XCTAssert(details.post.textExists("0 likes"), "Likes counter wasn't decremented")
    }
    
    func testPinPost() {
        openScreen()
        
        details.post.pin()
        
        let request = APIState.getLatestData(forService: "pins")

        XCTAssertEqual(request?["topicHandle"] as! String, "topicHandle")
        XCTAssert(details.post.pinButton.isSelected, "Post is not marked as pinned")
        
        details.post.pin()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/pins/topics"))
        XCTAssert(!details.post.pinButton.isSelected, "Post is marked as pinned")
    }
}
