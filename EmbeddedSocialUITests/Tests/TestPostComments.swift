//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BaseTestComments: BaseSideMenuTest {
    
    var pageSize: Int!
    var commentsFeed: CommentsFeed!
    
    override func setUp() {
        super.setUp()
        
        pageSize = 5
        commentsFeed = CommentsFeed(app)
    }
    
    override func openScreen() {
        Feed(app).getRandomPost().1.teaser.tap()
        
        var retryCount = 15
        while commentsFeed.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }
    
    func testCommentAttributes() {
        let (_, comment) = commentsFeed.getRandomComment()
        
        XCTAssert(comment.textExists("Alan Poe"), "Author name doesn't match")
        XCTAssertEqual(comment.likesButton.label, "5 likes", "Number of likes doesn't match")
        XCTAssertEqual(comment.repliesButton.label, "7 replies", "Number of comments doesn't match")
        XCTAssert(comment.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "Comment text doesn't match")
        XCTAssert(comment.likeButton.isSelected, "Post is not marked as liked")
    }
    
    func testLikeComment() {
        let (index, comment) = commentsFeed.getRandomComment()
        
        comment.like()
        checkIsLiked(comment, at: index)
        
        comment.like()
        checkIsUnliked(comment, at: index)
    }
    
    func checkIsLiked(_ comment: Comment, at index: UInt) {
        XCTAssert(comment.likeButton.isSelected, "Comment is not marked as liked")
        XCTAssertEqual(comment.likesButton.label, "1 like", "Likes counter wasn't incremented")
    }
    
    func checkIsUnliked(_ comment: Comment, at index: UInt) {
        XCTAssert(!comment.likeButton.isSelected, "Comment is marked as liked")
        XCTAssertEqual(comment.likesButton.label, "0 likes", "Likes counter wasn't decremented")
    }
    
    func testPaging() {
        tapLoadMore()
        
        var seenComments = Set<String>()
        var retryCount = 15
        
        while seenComments.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...commentsFeed.getCommentsCount() - 2 {
                let comment = commentsFeed.getComment(i)
                seenComments.insert(comment.likesButton.label)
            }
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(seenComments.count, pageSize, "New comments weren't loaded on tapping Load More")
    }
    
    func testPullToRefresh() {
        tapLoadMore()
        
        for _ in 0...2 {
            app.swipeDown()
        }
        
        let start = commentsFeed.feedContainer.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = commentsFeed.feedContainer.coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        XCTAssertTrue(commentsFeed.getCommentsCount() != 0)
    }
    
    func testCreateComment() {
        commentsFeed.commentText.tap()
        commentsFeed.commentText.clearText()
        commentsFeed.commentText.tap()
        commentsFeed.commentText.typeText("New Comment Text")
        commentsFeed.publishCommentButton.tap()
        
        sleep(1)
        let lastComment = commentsFeed.getComment(commentsFeed.getCommentsCount() - 1)
        XCTAssertTrue(lastComment.textExists("New Comment Text"))
    }
    
    func testOpenReplies() {
        APIConfig.values = ["text": "Replies screen"]
        commentsFeed.getComment(0).repliesButton.tap()
        XCTAssert(app.staticTexts["Replies screen"].exists, "Replies screen is not opened")
    }

    private func tapLoadMore() {
        var retryCount = 15
        
        while !commentsFeed.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeDown()
        }
        
        commentsFeed.loadMoreButton.tap()
        
        retryCount = 15
        while commentsFeed.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }
    
}

class TestCommentsOnline: BaseTestComments, OnlineTest {
    
    override func testCommentAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "totalReplies": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true]
        
        openScreen()
        super.testCommentAttributes()
    }
    
    override func testLikeComment() {
        openScreen()
        super.testLikeComment()
    }
    
    override func checkIsLiked(_ comment: Comment, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
    }
    
    override func checkIsUnliked(_ comment: Comment, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
    }
    
    override func testPaging() {
        APIConfig.numberedCommentLikes = true
        openScreen()
        super.testPaging()
    }
 
    override func testPullToRefresh() {
        openScreen()
        
        super.testPullToRefresh()
        
        let response = APIState.getLatestResponse(forService: "comments")
        XCTAssertEqual(Int(response?["cursor"] as! String), pageSize, "First page wasn't loaded on Pull to Refresh")
    }
    
    override func testCreateComment() {
        openScreen()
        
        super.testCreateComment()
        
        let request = APIState.getLatestData(forService: "comments")
        XCTAssertEqual(request?["text"] as! String, "New Comment Text")
    }
    
    override func testOpenReplies() {
        openScreen()
        super.testOpenReplies()
    }
    
}

class TestCommentsOffline: BaseTestComments, OfflineTest {
    
    override func testCommentAttributes() {
        APIConfig.values = ["user->firstName": "Alan",
                            "user->lastName": "Poe",
                            "totalLikes": 5,
                            "totalReplies": 7,
                            "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "liked": true]
        
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getComment(0).cell)
        super.testCommentAttributes()
    }
    
    override func testLikeComment() {
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getComment(0).cell)
        super.testLikeComment()
    }
    
    override func checkIsLiked(_ comment: Comment, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
    }
    
    override func checkIsUnliked(_ comment: Comment, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
    }
    
    override func testPaging() {
        APIConfig.numberedCommentLikes = true
        openScreen()
        
        super.testPaging()
        
        for _ in 1...14 {
            app.swipeDown()
        }
        
        makePullToRefreshWithoutReachability(with: commentsFeed.getComment(0).cell)
        
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getComment(0).cell)
        super.testPullToRefresh()
    }
    
    override func testCreateComment() {
        openScreen()
        
        for _ in 1...5 {
            app.swipeDown()
        }
        
//        makePullToRefreshWithoutReachability(with: commentsFeed.getComment(0).cell)
        
        APIConfig.delayedResponses = true
        
        super.testCreateComment()
    }
    
    override func testOpenReplies() {
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getComment(0).cell)
        super.testOpenReplies()
    }
    
}
