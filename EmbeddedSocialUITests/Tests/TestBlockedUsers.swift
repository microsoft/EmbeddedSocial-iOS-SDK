//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BaseTestBlockedUsers: BaseSideMenuTest {
    
    var pageSize: Int!
    var blockedUsersFeed: BlockedUsersFeed!
    
    override func setUp() {
        super.setUp()
        
        pageSize = Constants.UserList.pageSize
        blockedUsersFeed = BlockedUsersFeed(app)
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.showUserImages = false
    }
    
    override func openScreen() {
        navigate(to: .settings)
        app.cells["Blocked users"].tap()
    }
    
    func testImagesLoading() {}
    
    func testBlockedUsersAttributes() {
        let (index, blockedUserItem) = blockedUsersFeed.getRandomBlockedUserItem()
        
        XCTAssertNotNil(blockedUserItem)
        XCTAssertTrue(blockedUserItem.isExists(text: "Blocked User\(index)"))
        XCTAssertTrue(blockedUserItem.isValidAction(), "Wrong button text")
    }
    
    func testUnblockingUser() {
        let (index, blockedUserItem) = blockedUsersFeed.getRandomBlockedUserItem()
        
        let beforeUnblockingUsersCount = blockedUsersFeed.getBlockedUsersCount()
        blockedUserItem.unblock()
        checkIsUnblocked(user: blockedUserItem, at: index, beforeUnblockingCount: beforeUnblockingUsersCount)
    }
    
    func checkIsUnblocked(user: BlockedUserItem, at index: UInt, beforeUnblockingCount: UInt) {
        XCTAssertTrue((beforeUnblockingCount - 1) == blockedUsersFeed.getBlockedUsersCount())
    }
    
    func testPaging() {
        var retryCount = 10
        
        while blockedUsersFeed.getBlockedUsersCount() <= UInt(pageSize) && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(blockedUsersFeed.getBlockedUsersCount(), UInt(pageSize), "New users weren't loaded while swiping feed up")
    }
    
}

class TestBlockedUsersOnline: BaseTestBlockedUsers, OnlineTest {
    
    override func testBlockedUsersAttributes() {
        openScreen()
        super.testBlockedUsersAttributes()
    }
    
    override func testImagesLoading() {
        APIConfig.showUserImages = true
        
        openScreen()
        sleep(1)
        
        super.testImagesLoading()
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"), "Users images weren't loaded")
    }
    
    override func testUnblockingUser() {
        openScreen()
        super.testUnblockingUser()
    }
    
    override func checkIsUnblocked(user: BlockedUserItem, at index: UInt, beforeUnblockingCount: UInt) {
        XCTAssertTrue(APIState.getLatestRequest().hasSuffix("/me/blocked_users/BlockedUser\(index)"))
        XCTAssertEqual(APIState.latestRequstMethod, "DELETE")
    }
    
    override func testPaging() {
        openScreen()
        
        super.testPaging()
        
        let latestRequest = APIState.getLatestResponse(forService: "blockedUsers")
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
}

class TestBlockedUsersOffline: BaseTestBlockedUsers, OfflineTest {
    
    override func testBlockedUsersAttributes() {
        openScreen()
        makePullToRefreshWithoutReachability(with: blockedUsersFeed.getBlockedUserItem(at: 0).asUIElement())
        super.testBlockedUsersAttributes()
    }
    
    override func testUnblockingUser() {
        openScreen()
        makePullToRefreshWithoutReachability(with: blockedUsersFeed.getBlockedUserItem(at: 0).asUIElement())
        super.testUnblockingUser()
    }
    
    override func testPaging() {
        openScreen()
        
        // load items online
        super.testPaging()
        
        // scroll to up
        for _ in 1...16 {
            app.swipeDown()
        }
        
        makePullToRefreshWithoutReachability(with: blockedUsersFeed.getBlockedUserItem(at: 0, withScroll: false).asUIElement())
        
        // test offline pagination
        super.testPaging()
    }
    
}
