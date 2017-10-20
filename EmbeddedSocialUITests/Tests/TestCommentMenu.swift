//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestCommentMenu: TestOnlineHome {
    
    private var comments: CommentsFeed!
    private var commentInformation: (index: UInt, comment: Comment)!
    
    override func setUp() {
        super.setUp()
    
        comments = CommentsFeed(app)
    }
    
    override func openScreen() {
        feed.getRandomPost().1.teaser.tap()
        
        var retryCount = 15
        
        while comments.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }
    
    func testFollowAndUnfollow() {
        openScreen()
        
        commentInformation = comments.getRandomComment()
        
        // Follow test
        
        clearRequestsHistory()
        select(menuItem: .follow, for: commentInformation.comment)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let followingUser = APIState.getLatestData(forService: "followers")?["userHandle"] as? String
        XCTAssertNotNil(followingUser)
        
        // Unfollow test
        
        clearRequestsHistory()
        select(menuItem: .unfollow, for: commentInformation.comment)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users/\(followingUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testBlockAndUnblock() {
        openScreen()
        
        commentInformation = comments.getRandomComment()
        
        // Block test
        
        clearRequestsHistory()
        select(menuItem: .block, for: commentInformation.comment)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let blockedUser = APIState.getLatestData(forService: "blockedUsers")?["userHandle"] as? String
        XCTAssertNotNil(blockedUser)
        
        // unblock test
        
        clearRequestsHistory()
        select(menuItem: .unblock, for: commentInformation.comment)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users/\(blockedUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testReports() {
        openScreen()
        
        // Initialize values
        
        commentInformation = comments.getRandomComment()
        select(menuItem: .report, for: commentInformation.comment)
        
        let reportIssuesCells = app.tables.element.cells
        let submitReportButton = app.navigationBars.element.buttons.element(boundBy: 1)
        let doneButton = app.navigationBars.element.buttons.element
        
        for i in 0..<reportIssuesCells.count {
            // It's already opened for first item
            if i > 0 {
                // Open report item
                select(menuItem: .report, for: commentInformation.comment)
            }
            
            // Select issue cell
            
            let currentIssueCell = reportIssuesCells.element(boundBy: i)
            currentIssueCell.tap()
            submitReportButton.tap()
            
            let reportingCommentHandle = "commentHandle\(commentInformation.index)"
            XCTAssertTrue(APIState.getLatestRequest().hasSuffix("comments/\(reportingCommentHandle)/reports"))
            
            doneButton.tap()
        }
    }
    
}

extension TestCommentMenu {
    
    fileprivate func clearRequestsHistory() {
        APIState.requestHistory.removeAll()
    }
    
    fileprivate func select(menuItem: CommentMenuItem, for comment: Comment) {
        XCTAssert(comment.menu().isExists(item: menuItem), "Menu item - \"\(menuItem.rawValue)\" does not exists!")
        comment.menu().select(item: menuItem)
    }
    
}
