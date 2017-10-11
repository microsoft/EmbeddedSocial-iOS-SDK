//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestPostMenu: TestOnlineHome, OnlineTest {
    
    private var randomFeedPostInformation: (index: UInt, post: Post)!
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
    }
    
    func testFollowAndUnfollow() {
        openScreen()
        
        randomFeedPostInformation = feed.getRandomPost()
        
        // Follow test
        
        clearRequestsHistory()
        select(menuItem: .follow, for: randomFeedPostInformation.post)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let followingUser = APIState.getLatestData(forService: "followers")?["userHandle"] as? String
        XCTAssertNotNil(followingUser)
        
        // Unfollow test
        
        clearRequestsHistory()
        select(menuItem: .unfollow, for: randomFeedPostInformation.post)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users/\(followingUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testBlockAndUnblock() {
        openScreen()
        
        randomFeedPostInformation = feed.getRandomPost()
        
        // Block test
        
        clearRequestsHistory()
        select(menuItem: .block, for: randomFeedPostInformation.post)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let blockedUser = APIState.getLatestData(forService: "blockedUsers")?["userHandle"] as? String
        XCTAssertNotNil(blockedUser)
        
        // unblock test
        
        clearRequestsHistory()
        select(menuItem: .unblock, for: randomFeedPostInformation.post)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users/\(blockedUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testReports() {
        feedName = "me"

        openScreen()
        
        // Initialize values
        
        randomFeedPostInformation = feed.getRandomPost()
        select(menuItem: .report, for: randomFeedPostInformation.post)

        let reportIssuesCells = app.tables.element.cells
        let submitReportButton = app.navigationBars.element.buttons.element(boundBy: 1)
        let doneButton = app.navigationBars.element.buttons.element
        
        for i in 0..<reportIssuesCells.count {
            // It's already opened for first item
            if i > 0 {
                // Get new post and open report item                
                randomFeedPostInformation = feed.getRandomPost()
                select(menuItem: .report, for: randomFeedPostInformation.post)
            }
            
            // Select issue cell
            
            let currentIssueCell = reportIssuesCells.element(boundBy: i)
            currentIssueCell.tap()
            submitReportButton.tap()
            
            let reportingPostTitle = feedName + "\(randomFeedPostInformation.index)"
            XCTAssertTrue(APIState.getLatestRequest().hasSuffix("/\(reportingPostTitle)/reports"))
            
            doneButton.tap()
        }
    }
    
}

extension TestPostMenu {
    
    fileprivate func clearRequestsHistory() {
        APIState.requestHistory.removeAll()
    }
    
    fileprivate func select(menuItem: PostMenuItem, for post: Post) {
        XCTAssert(post.menu().isExists(item: menuItem), "Menu item - \"\(menuItem.rawValue)\" does not exists!")
        post.menu().select(item: menuItem)
    }
    
}
