//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestPostMenu: TestHome {
    
    fileprivate var randomFeedPost: Post!
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
    }
    
    func testFollowAndUnfollow() {
        openScreen()
        
        randomFeedPost = feed.getRandomPost().1
        
        // Follow test
        
        clearRequestsHistory()
        select(menuItem: .follow, for: randomFeedPost)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        // Unfollow test
        
        clearRequestsHistory()
        select(menuItem: .unfollow, for: randomFeedPost)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/following/users"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
    func testBlockAndUnblock() {
        openScreen()
        
        randomFeedPost = feed.getRandomPost().1
        
        // Block test
        
        clearRequestsHistory()
        select(menuItem: .block, for: randomFeedPost)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        
        // unblock test
        
        clearRequestsHistory()
        select(menuItem: .unblock, for: randomFeedPost)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("me/blocked_users"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
}

extension TestPostMenu {
    
    fileprivate func clearRequestsHistory() {
        APIState.requestHistory.removeAll()
    }
    
    fileprivate func select(menuItem: PostMenuItem, for post: Post) {
        XCTAssert(randomFeedPost.menu().isExists(item: menuItem), "Menu item - \"\(menuItem.rawValue)\" does not exists!")
        randomFeedPost.menu().select(item: menuItem)
    }
    
}
