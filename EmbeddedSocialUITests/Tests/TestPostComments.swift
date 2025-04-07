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
        pageSize = 20
    }
    
    override func openScreen() {
        Feed(app).getRandomItem().1.getTitle().tap()
        commentsFeed = PostDetails(app).comments

//        var retryCount = 15
//        while commentsFeed.loadMoreButton.exists && retryCount != 0 {
//            retryCount -= 1
//            app.swipeUp()
//        }
    }
    
    func testCommentAttributes() {
        let (_, comment) = commentsFeed.getRandomItem()
        
        XCTAssert(comment.isExists("Alan Poe"), "Author name doesn't match")
        XCTAssertEqual(comment.likesButton.label, "5 likes", "Number of likes doesn't match")
        XCTAssertEqual(comment.repliesButton.label, "7 replies", "Number of comments doesn't match")
        XCTAssert(comment.isExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "Comment text doesn't match")
        XCTAssert(!comment.likeButton.isSelected, "Post is marked as liked")
    }
    
    func testLikeComment() {
        let (index, comment) = commentsFeed.getRandomItem()
        
        comment.like()
        checkIsLiked(comment, at: index)
        
        comment.like()
        checkIsUnliked(comment, at: index)
    }
    
    func checkIsLiked(_ comment: CommentItem, at index: UInt) {
        XCTAssert(comment.likeButton.isSelected, "Comment is not marked as liked")
        XCTAssertEqual(comment.likesButton.label, "1 like", "Likes counter wasn't incremented")
    }
    
    func checkIsUnliked(_ comment: CommentItem, at index: UInt) {
        XCTAssert(!comment.likeButton.isSelected, "Comment is marked as liked")
        XCTAssertEqual(comment.likesButton.label, "0 likes", "Likes counter wasn't decremented")
    }
    
    func testPaging() {
        tapLoadMore()
        
        var seenComments = Set<XCUIElement>()
        var retryCount = 15
        
        while seenComments.count <= pageSize && retryCount != 0 {
            retryCount -= 1
            for i in 0...commentsFeed.getItemsCount() - 2 {
                let comment = commentsFeed.getItem(at: i, withScroll: false)
                seenComments.insert(comment.asUIElement())
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
        
        let start = commentsFeed.asUIElement().coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 0)))
        let finish = commentsFeed.asUIElement().coordinate(withNormalizedOffset: (CGVector(dx: 0, dy: 6)))
        start.press(forDuration: 0, thenDragTo: finish)
        
        XCTAssertTrue(commentsFeed.getItemsCount() != 0)
    }
    
    func testCreateComment() {
        commentsFeed.postNewComment(with: "New Comment Text")
        
        sleep(UInt32(APIConfig.responsesDelay + 2))
        
        let lastComment = commentsFeed.getItem(at: commentsFeed.getItemsCount() - 1, withScroll: false)
        XCTAssertTrue(lastComment.isExists("New Comment Text"))
    }
    
    func testOpenReplies() {
        APIConfig.values = ["text": "Replies screen"]
        commentsFeed.getItem(at: 0).openReplies()
        XCTAssert(app.staticTexts["Replies screen"].exists, "Replies screen is not opened")
    }

    private func tapLoadMore() {
        var retryCount = 15

        while !commentsFeed.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeDown()
        }
        
        let loadMoreButton = commentsFeed.loadMoreButton
        if loadMoreButton.exists {
            loadMoreButton.tap()
        }

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
                            "liked": false]
        
        openScreen()
        super.testCommentAttributes()
    }
    
    override func testLikeComment() {
        openScreen()
        super.testLikeComment()
    }
    
    override func checkIsLiked(_ comment: CommentItem, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
    }
    
    override func checkIsUnliked(_ comment: CommentItem, at index: UInt) {
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
        XCTAssertGreaterThanOrEqual(Int(response?["cursor"] as! String)!, pageSize, "First page wasn't loaded on Pull to Refresh")
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
                            "liked": false]
        
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getItem(at: 0).asUIElement())
        super.testCommentAttributes()
    }
    
    override func testLikeComment() {
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getItem(at: 0).asUIElement())
        super.testLikeComment()
    }
    
    override func checkIsLiked(_ comment: CommentItem, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes"))
    }
    
    override func checkIsUnliked(_ comment: CommentItem, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("/likes/me"))
    }
    
    override func testPaging() {
        APIConfig.numberedCommentLikes = true
        openScreen()
        
        super.testPaging()
        
        for _ in 1...14 {
            app.swipeDown()
        }
        
        makePullToRefreshWithoutReachability(with: commentsFeed.getItem(at: 0).asUIElement())
        
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        openScreen()
        makePullToRefreshWithoutReachability(with: commentsFeed.getItem(at: 0).asUIElement())
        super.testPullToRefresh()
    }
    
    override func testCreateComment() {
        openScreen()
        
        for _ in 1...5 {
            app.swipeDown()
        }
        
        makePullToRefreshWithoutReachability(with: commentsFeed.getItem(at: 0).asUIElement())
        super.testCreateComment()
    }
    
    override func testOpenReplies() {
        openScreen()
        
        super.testOpenReplies()
        app.navigationBars.element.buttons["Back"].tap()
        
        makePullToRefreshWithoutReachability(with: commentsFeed.getItem(at: 0).asUIElement())
        super.testOpenReplies()
    }
    
}
