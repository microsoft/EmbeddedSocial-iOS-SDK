//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest
@testable import EmbeddedSocial

class TestReplies: UITestBase {
    var sideMenu: SideMenu!
    var feed: Feed!
    var comments: CommentsFeed!
    var replies: RepliesFeed!
    var pageSize: Int!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        feed = Feed(app)
        comments = CommentsFeed(app)
        replies = RepliesFeed(app)
        pageSize = EmbeddedSocial.Constants.CommentReplies.pageSize
    }
    
    func openScreen() {
        sideMenu.navigateTo("Home")
        let (_, post) = feed.getRandomPost()
        post.teaser.tap()
        let comment = comments.getComment(0)
        comment.replyButton.tap()
        sleep(1)
    }
    
    func tapLoadMore() {
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
    
    func testReplyAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true]
        
        openScreen()
        
        let (_, reply) = replies.getRandomReply()
        
        XCTAssert(reply.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssertEqual(reply.likesButton.label, "5 likes", "Number of likes doesn't match")
        XCTAssert(reply.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "Reply text doesn't match")
        XCTAssert(reply.likeButton.isSelected, "Reply is not marked as liked")
    }
    
    func testLikeReply() {
        openScreen()
        
        let (_, reply) = replies.getRandomReply()
        
        reply.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
        XCTAssert(reply.likeButton.isSelected, "Reply is not marked as liked")
        XCTAssertEqual(reply.likesButton.label, "1 like", "Likes counter wasn't incremented")
        
        reply.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
        XCTAssert(!reply.likeButton.isSelected, "Reply is marked as liked")
        XCTAssertEqual(reply.likesButton.label, "0 likes", "Likes counter wasn't decremented")
    }

    func testPaging() {
        APIConfig.numberedCommentLikes = true
        
        openScreen()
        
        tapLoadMore()
        
        var seenReplies = Set<String>()
        var retryCount = 15
        
        while seenReplies.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...replies.getRepliesCount() - 1 {
                let comment = replies.getReply(i)
                seenReplies.insert(comment.likesButton.label)
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenReplies.count, pageSize, "New comments weren't loaded on tapping Load More")
    }

    func testPullToRefresh() {
        openScreen()
        
        tapLoadMore()
        
        for _ in 0...2 {
            app.swipeDown()
        }
        
        let start = replies.feedContainer.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = replies.feedContainer.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        let response = APIState.getLatestResponse(forService: "replies")
        
        XCTAssertEqual(Int(response?["cursor"] as! String), pageSize, "First page wasn't loaded on Pull to Refresh")
    }

    func testCreateReply() {
        openScreen()
        
        replies.replyText.tap()
        replies.replyText.clearText()
        replies.replyText.tap()
        replies.replyText.typeText("Reply Text")
        replies.publishReplyButton.tap()
        
        let request = APIState.getLatestData(forService: "replies")
        
        XCTAssertEqual(request?["text"] as! String, "Reply Text")
    }
}


