//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest
@testable import EmbeddedSocial

class TestPostComments: UITestBase {
    var sideMenu: SideMenu!
    var feed: Feed!
    var comments: CommentsFeed!
    var pageSize: Int!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        feed = Feed(app)
        comments = CommentsFeed(app)
        pageSize = EmbeddedSocial.Constants.CommentReplies.pageSize
    }
    
    func openScreen() {
        sideMenu.navigate(to: .home)
        let (_, post) = feed.getRandomPost()
        post.teaser.tap()
        sleep(1)
        
        var retryCount = 15
        
        while comments.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }
    
    func tapLoadMore() {
        var retryCount = 15
        
        while !comments.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeDown()
        }
        
        comments.loadMoreButton.tap()
        
        retryCount = 15
        
        while comments.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }


    func testCommentAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "totalReplies": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true]
        
        openScreen()
        
        let (_, comment) = comments.getRandomComment()
        
        XCTAssert(comment.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssertEqual(comment.likesButton.label, "5 likes", "Number of likes doesn't match")
        XCTAssertEqual(comment.repliesButton.label, "7 replies", "Number of comments doesn't match")
        XCTAssert(comment.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "Comment text doesn't match")
        XCTAssert(comment.likeButton.isSelected, "Post is not marked as liked")
    }
    
    func testLikeComment() {
        openScreen()
        
        let (_, comment) = comments.getRandomComment()
        
        comment.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
        XCTAssert(comment.likeButton.isSelected, "Comment is not marked as liked")
        XCTAssertEqual(comment.likesButton.label, "1 like", "Likes counter wasn't incremented")
        
        comment.like()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
        XCTAssert(!comment.likeButton.isSelected, "Comment is marked as liked")
        XCTAssertEqual(comment.likesButton.label, "0 likes", "Likes counter wasn't decremented")
    }
    
    func testPaging() {
        APIConfig.numberedCommentLikes = true
        
        openScreen()
        
        tapLoadMore()
        
        var seenComments = Set<String>()
        var retryCount = 15
        
        while seenComments.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...comments.getCommentsCount() - 2 {
                let comment = comments.getComment(i)
                seenComments.insert(comment.likesButton.label)
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenComments.count, pageSize, "New comments weren't loaded on tapping Load More")
    }
    
    func testPullToRefresh() {
        openScreen()
        
        tapLoadMore()
        
        for _ in 0...2 {
            app.swipeDown()
        }
        
        let start = comments.feedContainer.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = comments.feedContainer.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        let response = APIState.getLatestResponse(forService: "comments")
        
        XCTAssertEqual(Int(response?["cursor"] as! String), pageSize, "First page wasn't loaded on Pull to Refresh")
    }
    
    func testCreateComment() {
        openScreen()
        
        comments.commentText.tap()
        comments.commentText.clearText()
        comments.commentText.tap()
        comments.commentText.typeText("Comment Text")
        comments.publishCommentButton.tap()
        
        let request = APIState.getLatestData(forService: "comments")
        
        XCTAssertEqual(request?["text"] as! String, "Comment Text")
    }
    
    func testOpenReplies() {
        openScreen()
        
        APIConfig.values = ["text": "Replies screen"]
        
        let (_, comment) = comments.getRandomComment()
        
        comment.repliesButton.tap()
        
        XCTAssert(app.staticTexts["Replies screen"].exists, "Replies screen is not opened")
    }
}


