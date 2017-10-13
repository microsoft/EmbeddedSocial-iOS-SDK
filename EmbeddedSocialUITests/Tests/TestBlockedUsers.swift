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
//        let currentBlockedUsersCount = blockedUsersFeed.getBlockedUsersCount()
//        
//        // move to the last item
//        let _ = blockedUsersFeed.getBlockedUserItem(at: currentBlockedUsersCount - 1)
//        app.swipeUp()
//        
//        // get new list size after loading
//        let newBlockedUsersCount = blockedUsersFeed.getBlockedUsersCount()
//        XCTAssertGreaterThan(newBlockedUsersCount, currentBlockedUsersCount)
        
        var seenUsers = Set<XCUIElement>()
        var retryCount = 25
        
        while seenUsers.count <= pageSize! || retryCount != 0 {
            retryCount -= 1
            for i in 0...blockedUsersFeed.getBlockedUsersCount() - 1 {
                let blockedUserItem = blockedUsersFeed.getBlockedUserItem(at: i)
                seenUsers.insert(blockedUserItem.asUIElement())
            }
            app.swipeUp()
            
            print("SEEN ITEMS: \(seenUsers.count) of \(pageSize)")
        }
        XCTAssertGreaterThan(seenUsers.count, pageSize, "New users weren't loaded while feed up")
    }
}

class TestBlockedUsersOnline: BaseTestBlockedUsers, OnlineTest {
    
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
        let _ = blockedUsersFeed.getBlockedUserItem(at: 0)
        
        makePullToRefreshWithoutReachability(with: blockedUsersFeed.getBlockedUserItem(at: 0).asUIElement())
        
        // test offline pagination
        super.testPaging()
    }
    
}
