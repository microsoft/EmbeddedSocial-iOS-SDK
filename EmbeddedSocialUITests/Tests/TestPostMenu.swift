//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestPostMenu: TestOnlineHome {
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
    }
    
    func testFollowAndUnfollow() {
        openScreen()
        
        let (_, post) = feed.getRandomPost()
        
        // Follow test
        
        select(menuItem: .follow, for: post)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let followingUser = APIState.getLatestData(forService: "followers")?["userHandle"] as? String
        XCTAssertNotNil(followingUser)
        
        // Unfollow test
        
        select(menuItem: .unfollow, for: post)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users/\(followingUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testBlockAndUnblock() {
        openScreen()
        
        let (_, post) = feed.getRandomPost()
        
        // Block test
        
        select(menuItem: .block, for: post)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        let blockedUser = APIState.getLatestData(forService: "blockedUsers")?["userHandle"] as? String
        XCTAssertNotNil(blockedUser)
        
        // unblock test
        
        select(menuItem: .unblock, for: post)
        sleep(1)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users/\(blockedUser!)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testReports() {
        openScreen()
        
        // Initialize values
        
        var (_, post) = feed.getRandomPost()
        let reportingPostTitle = post.getTitle().label
        
        select(menuItem: .report, for: post)

        let reportIssuesCells = app.tables.element.cells
        let submitReportButton = app.navigationBars.element.buttons.element(boundBy: 1)
        let doneButton = app.navigationBars.element.buttons.element
        
        for i in 0..<reportIssuesCells.count {
            // It's already opened for first item
            if i > 0 {
                // Get new post and open report item
                select(menuItem: .report, for: post)
            }
            
            // Select issue cell
            
            let currentIssueCell = reportIssuesCells.element(boundBy: i)
            currentIssueCell.tap()
            submitReportButton.tap()
            
            XCTAssertTrue(APIState.getLatestRequest().hasSuffix("/\(reportingPostTitle)/reports"))
            
            doneButton.tap()
        }
    }
    
}

extension TestPostMenu {
    
    fileprivate func select(menuItem: PostMenuItem, for post: Post) {
        XCTAssert(post.menu().isExists(item: menuItem), "Menu item - \"\(menuItem.rawValue)\" does not exists!")
        post.menu().select(item: menuItem)
    }
    
}
