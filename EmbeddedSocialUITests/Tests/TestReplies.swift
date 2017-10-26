//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BaseTestReplies: BaseSideMenuTest {
    
    var replies: RepliesFeed!
    var pageSize: Int!
    
    override func setUp() {
        super.setUp()
        pageSize = 20
    }
    
    override func openScreen() {
        Feed(app).getPost(0).asUIElement().tap()
        let comments = PostDetails(app).comments!
        
//        var retryCount = 15
//
//        while comments.loadMoreButton.exists && retryCount != 0 {
//            retryCount -= 1
//            app.swipeUp()
//        }
        
        let comment = comments.getComment(0)
        comment.replyButton.tap()
        sleep(1)
        
        replies = RepliesFeed(app, containerView: app.collectionViews.firstMatch)
    }
    
    func testReplyAttributes() {
        let (_, reply) = replies.getRandomReply()
        
        XCTAssert(reply.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssertEqual(reply.likesButton.label, "5 likes", "Number of likes doesn't match")
        XCTAssert(reply.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "Reply text doesn't match")
        XCTAssert(reply.likeButton.isSelected, "Reply is not marked as liked")
    }
    
    func testLikeReply() {
        let (_, reply) = replies.getRandomReply()
        
        reply.like()
        checkIsLiked(reply)
        
        reply.like()
        checkIsDisliked(reply)
    }
    
    func checkIsLiked(_ reply: Reply) {
        XCTAssert(reply.likeButton.isSelected, "Reply is not marked as liked")
        XCTAssertEqual(reply.likesButton.label, "1 like", "Likes counter wasn't incremented")
    }
    
    func checkIsDisliked(_ reply: Reply) {
        XCTAssert(!reply.likeButton.isSelected, "Reply is marked as liked")
        XCTAssertEqual(reply.likesButton.label, "0 likes", "Likes counter wasn't decremented")
    }
    
    func testPaging() {
        tapLoadMore()
        
        var seenReplies = Set<XCUIElement>()
        var retryCount = 15
        
        while seenReplies.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...replies.getRepliesCount() - 1 {
                let reply = replies.getReply(i)
                seenReplies.insert(reply.asUIElement())
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenReplies.count, pageSize, "New comments weren't loaded on tapping Load More")
    }
    
    func testPullToRefresh() {
        tapLoadMore()
        
        for _ in 0...2 {
            app.swipeDown()
        }
        
        let start = replies.asUIElement().coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = replies.asUIElement().coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        XCTAssertTrue(replies.getRepliesCount() != 0)
    }
    
    func testCreateReply() {
        replies.publishWith(text: "New Reply Text")
        sleep(1)
        
        let lastReply = replies.getReply(replies.getRepliesCount() - 1)
        XCTAssertTrue(lastReply.textExists("New Reply Text"))
    }
    
    private func tapLoadMore() {
        var retryCount = 15
        
        while !replies.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeDown()
        }
        
        replies.loadMoreButton.tap()
        
        retryCount = 15
        
        while replies.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }
    
}

class TestRepliesOnline: BaseTestReplies, OnlineTest {
    
    override func testReplyAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true]
        
        openScreen()
        super.testReplyAttributes()
    }
    
    override func testLikeReply() {
        openScreen()
        super.testLikeReply()
    }
    
    override func checkIsLiked(_ reply: Reply) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
        super.checkIsLiked(reply)
    }
    
    override func checkIsDisliked(_ reply: Reply) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
        super.checkIsDisliked(reply)
    }
    
    override func testPaging() {
        openScreen()
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        openScreen()
        
        super.testPullToRefresh()
        
        let response = APIState.getLatestResponse(forService: "replies")
        XCTAssertEqual(Int(response?["cursor"] as! String), pageSize, "First page wasn't loaded on Pull to Refresh")
    }
    
    override func testCreateReply() {
        openScreen()
        
        super.testCreateReply()
        
        let request = APIState.getLatestData(forService: "replies")
        XCTAssertEqual(request?["text"] as! String, "New Reply Text")
    }
    
}

class TestRepliesOffline: BaseTestReplies, OfflineTest {
    
    override func testReplyAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true]
        
        openScreen()
        app.statusBars.element.tap()
        makePullToRefreshWithoutReachability(with: replies.asUIElement())
        super.testReplyAttributes()
    }
    
    override func testLikeReply() {
        openScreen()
        app.statusBars.element.tap()
        makePullToRefreshWithoutReachability(with: replies.asUIElement())
        super.testLikeReply()
    }
    
    override func testPaging() {
        openScreen()
        
        super.testPaging()
        
        app.statusBars.element.tap()
        makePullToRefreshWithoutReachability(with: replies.asUIElement())
        
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        openScreen()
        app.statusBars.element.tap()
        makePullToRefreshWithoutReachability(with: replies.asUIElement())
        super.testPullToRefresh()
    }
    
    override func testCreateReply() {
        openScreen()
        app.statusBars.element.tap()
        makePullToRefreshWithoutReachability(with: replies.asUIElement())
        super.testCreateReply()
    }
    
}
