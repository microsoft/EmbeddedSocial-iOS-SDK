//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestCommentMenu: BaseSideMenuTest {
    
    private var comments: CommentsFeed!
    
    override func setUp() {
        super.setUp()
        APIConfig.showCommentHandleInTeaser = true
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.showCommentHandleInTeaser = false
    }
    
    override func openScreen() {
        Feed(app).getRandomItem().1.getTitle().tap()
        
        comments = PostDetails(app).comments
        
        var retryCount = 15
        
        while comments.loadMoreButton.exists && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
    }
    
    func testFollowAndUnfollow() {
        openScreen()
        
        let (_, comment) = comments.getRandomItem()
        
        // Follow test
        
        select(menuItem: .follow, for: comment)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let followingUser = APIState.getLatestData(forService: "followers")?["userHandle"] as? String
        XCTAssertNotNil(followingUser)
        
        // Unfollow test
        
        select(menuItem: .unfollow, for: comment)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users/\(followingUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testBlockAndUnblock() {
        openScreen()
        
        let (_, comment) = comments.getRandomItem()
        
        // Block test
        
        select(menuItem: .block, for: comment)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let blockedUser = APIState.getLatestData(forService: "blockedUsers")?["userHandle"] as? String
        XCTAssertNotNil(blockedUser)
        
        // unblock test
        
        select(menuItem: .unblock, for: comment)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users/\(blockedUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testReports() {
        openScreen()
        
        // Initialize values
        
        let (_, comment) = comments.getRandomItem()
        let reportingCommentHandle = comment.getTitle().label
        select(menuItem: .report, for: comment)
        
        let reportIssuesCells = app.tables.element.cells
        let submitReportButton = app.navigationBars.element.buttons.element(boundBy: 1)
        let doneButton = app.navigationBars.element.buttons.element
        
        for i in 0..<reportIssuesCells.count {
            // It's already opened for first item
            if i > 0 {
                // Open report item
                select(menuItem: .report, for: comment)
            }
            
            // Select issue cell
            
            let currentIssueCell = reportIssuesCells.element(boundBy: i)
            currentIssueCell.tap()
            submitReportButton.tap()
            
            XCTAssertTrue(APIState.getLatestRequest().hasSuffix("comments/\(reportingCommentHandle)/reports"))
            
            doneButton.tap()
        }
    }
    
}

extension TestCommentMenu {
    
    fileprivate func select(menuItem: CommentMenuItem, for comment: CommentItem) {
        XCTAssert(comment.menu().isExists(item: menuItem), "Menu item - \"\(menuItem.rawValue)\" does not exists!")
        comment.menu().select(item: menuItem)
    }
    
}
