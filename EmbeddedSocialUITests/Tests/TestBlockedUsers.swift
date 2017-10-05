//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class TestBlockedUsers: UITestBase {
    
    private let pageSize: Int = Constants.UserList.pageSize
    
    private var sideMenu: SideMenu!
    private var blockedUsers: BlockedUsersFeed!
    
    override func setUp() {
        super.setUp()
        
        sideMenu = SideMenu(app)
        blockedUsers = BlockedUsersFeed(app)
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.showUserImages = false
    }
    
    func openBlockedUsersScreen() {
        sideMenu.navigate(to: .settings)
        app.cells["Blocked users"].tap()
    }
        
    func testImagesLoading() {
        APIConfig.showUserImages = true
        
        openBlockedUsersScreen()
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"))
    }
    
    func testBlockedUsersAttributes() {
        openBlockedUsersScreen()
        
        let (index, blockedUserItem) = blockedUsers.getRandomBlockedUserItem()
        
        XCTAssertNotNil(blockedUserItem)
        XCTAssertTrue(blockedUserItem.isExists(text: "Blocked User\(index)"))
        XCTAssertTrue(blockedUserItem.isValidAction(), "Wrong button text")
    }
    
    func testUnblockingUser() {
        openBlockedUsersScreen()
        
        let (index, blockedUserItem) = blockedUsers.getRandomBlockedUserItem()
        XCTAssertNotNil(blockedUserItem)
        
        let beforeUnblockingUsersCount = blockedUsers.getBlockedUsersCount()
        blockedUserItem.unblock()
        
        XCTAssertTrue((beforeUnblockingUsersCount - 1) == blockedUsers.getBlockedUsersCount())
        XCTAssertTrue(APIState.getLatestRequest().hasSuffix("/me/blocked_users/BlockedUser\(index)"))
        XCTAssertEqual(APIState.latestRequstMethod, "DELETE")
    }
    
    func testPaging() {
        openBlockedUsersScreen()
        
        let currentBlockedUsersCount = blockedUsers.getBlockedUsersCount()
        
        // move to the last item
        let _ = blockedUsers.getBlockedUserItem(at: currentBlockedUsersCount - 1)
        app.swipeUp()
        
        // get new list size after loading
        let newBlockedUsersCount = blockedUsers.getBlockedUsersCount()
        XCTAssertGreaterThan(newBlockedUsersCount, currentBlockedUsersCount)
        
        let latestRequest = APIState.getLatestResponse(forService: "blockedUsers")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
}
