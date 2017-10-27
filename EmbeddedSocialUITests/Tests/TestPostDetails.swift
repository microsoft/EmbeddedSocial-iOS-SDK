//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestPostDetails: BaseSideMenuTest {
    
    var details: PostDetails!
    
    override func setUp() {
        super.setUp()
        details = PostDetails(app)
    }
    
    override func openScreen() {
        Feed(app).getPost(0).asUIElement().tap()
    }
    
    func testPostAttributes() {
        XCTAssert(details.post.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssert(details.post.textExists("5 likes"), "Number of likes doesn't match")
        XCTAssert(details.post.textExists("7 comments"), "Number of comments doesn't match")
        XCTAssert(details.post.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "Teaser text doesn't match")
        XCTAssert(details.post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(details.post.pinButton.isSelected, "Post is not marked as pinned")
    }
    
    func testLikePost() {
        let post = details.post
        
        post.like()
        checkIsLiked(post)
        
        post.like()
        checkIsDisliked(post)
    }
    
    func checkIsLiked(_ post: Post) {
        XCTAssert(post.likeButton.isSelected, "Post is not marked as liked")
        XCTAssert(post.textExists("1 like"), "Likes counter wasn't incremented")
    }
    
    func checkIsDisliked(_ post: Post) {
        XCTAssert(!post.likeButton.isSelected, "Post is marked as liked")
        XCTAssert(post.textExists("0 likes"), "Likes counter wasn't decremented")
    }
    
    func testPinPost() {
        let post = details.post
        
        post.pin()
        checkIsPinned(post)
        
        post.pin()
        checkIsUnpinned(post)
    }
    
    func checkIsPinned(_ post: Post) {
        XCTAssert(post.pinButton.isSelected, "Post is not marked as pinned")
    }
    
    func checkIsUnpinned(_ post: Post) {
        XCTAssert(!post.pinButton.isSelected, "Post is marked as pinned")
    }
    
}

class TestPostDetailsOnline: BaseTestPostDetails, OnlineTest {
    
    override func testPostAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
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
    
    override func checkIsLiked(_ post: Post) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
        super.checkIsLiked(post)
    }
    
    override func checkIsDisliked(_ post: Post) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
        super.checkIsDisliked(post)
    }
    
    override func testPinPost() {
        openScreen()
        super.testPinPost()
    }
    
    override func checkIsPinned(_ post: Post) {
        let request = APIState.getLatestData(forService: "pins")
        XCTAssertEqual(request?["topicHandle"] as! String, "topicHandle")
        super.checkIsPinned(post)
    }
    
    override func checkIsUnpinned(_ post: Post) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/pins/topics"))
        super.checkIsUnpinned(post)
    }
    
}

class TestPostDetailsOffline: BaseTestPostDetails, OfflineTest {
    
    override func testPostAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "totalComments": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true,
                            "pinned": true]
        
        openScreen()
        makePullToRefreshWithoutReachability(with: details.asUIElement())
        super.testPostAttributes()
    }
    
    override func testLikePost() {
        openScreen()
        makePullToRefreshWithoutReachability(with: details.asUIElement())
        super.testLikePost()
    }
    
    override func testPinPost() {
        openScreen()
        makePullToRefreshWithoutReachability(with: details.asUIElement())
        super.testPinPost()
    }
    
}
