//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class BaseTestFollowers: BaseSideMenuTest {
    
    var feedName: String!
    var feedHandle: String!
    var pageSize: Int!
    
    var profile: UserProfile!
    var followersFeed: FollowersFeed!
    
    /*
     Expected button title
     
     Depending on user status, for example:
     Status: "Follow", Expected title: "FOLLOWING"
     */
    var followerAction: String!
    
    override func setUp() {
        super.setUp()
        
        profile = UserProfile(app)
        followersFeed = FollowersFeed(app)
        
        feedName = "User Follower"
        feedHandle = "UserFollower"
        pageSize = EmbeddedSocial.Constants.UserList.pageSize
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.showUserImages = false
    }
    
    override func openScreen() {
        navigate(to: .userProfile)
        profile.followersButton.tap()
    }
    
    func testFeedSource() {
        let (index, follower) = followersFeed.getRandomItem()
        XCTAssert(follower.isExists(feedName + String(index)), "Incorrect feed source")
    }
    
    func testUserListAttributes() {
        let (_, follower) = followersFeed.getRandomItem()
        XCTAssertEqual(follower.followButton.label, followerAction, "Users are not marked as expected")
    }
    
    func testUserFollowing() {
        let (index, follower) = followersFeed.getRandomItem()
        
        follower.follow()
        checkIsFollowed(follower, at: index)
        
        follower.follow()
        checkIsUnfollowed(follower, at: index)
    }
    
    func checkIsFollowed(_ follower: FollowerItem, at index: UInt) {
        XCTAssertEqual(follower.followButton.label, "FOLLOWING", "User is not marked as following")
    }
    
    func checkIsUnfollowed(_ follower: FollowerItem, at index: UInt) {
        XCTAssertEqual(follower.followButton.label, "FOLLOW", "User is marked as following")
    }
    
    func testPaging() {
        var retryCount = 10
        
        while followersFeed.getItemsCount() <= UInt(pageSize) && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(followersFeed.getItemsCount(), UInt(pageSize), "New users weren't loaded while swiping feed up")
    }
    
    func testUserImagesLoaded() {}
    
}

class TestFollowersOnline: BaseTestFollowers, OnlineTest {
    
    override func testFeedSource() {
        openScreen()
        super.testFeedSource()
    }
    
    override func testUserListAttributes() {
        APIConfig.values = ["followerStatus": "Follow"]
        
        openScreen()
        followerAction = "FOLLOWING"
        super.testUserListAttributes()
    }
    
    override func testUserFollowing() {
        openScreen()
        super.testUserFollowing()
    }
    
    override func checkIsFollowed(_ follower: FollowerItem, at index: UInt) {
        let request = APIState.getLatestData(forService: "followers")
        XCTAssertEqual(request?["userHandle"] as! String, feedHandle + String(index))
        super.checkIsFollowed(follower, at: index)
    }
    
    override func checkIsUnfollowed(_ follower: FollowerItem, at index: UInt) {
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/following/users/" + feedHandle + String(index)))
        super.checkIsUnfollowed(follower, at: index)
    }
    
    override func testPaging() {
        openScreen()
        super.testPaging()
    }
    
    override func testUserImagesLoaded() {
        APIConfig.showUserImages = true
        
        openScreen()
        
        XCTAssertNotNil(XCTAssertNotNil(APIState.getLatestRequest().contains("/images/")), "Post images weren't loaded")
    }
    
}

class TestFollowersOffline: BaseTestFollowers, OfflineTest {
    
    override func testFeedSource() {
        openScreen()
        makePullToRefreshWithoutReachability(with: followersFeed.getItem(at: 0).cell)
        super.testFeedSource()
    }
    
    override func testUserListAttributes() {
        APIConfig.values = ["followerStatus": "Follow"]
        
        openScreen()
        makePullToRefreshWithoutReachability(with: followersFeed.getItem(at: 0).cell)

        followerAction = "FOLLOWING"
        super.testUserListAttributes()
    }
    
    override func testUserFollowing() {
        openScreen()
        makePullToRefreshWithoutReachability(with: followersFeed.getItem(at: 0).cell)
        super.testUserFollowing()
    }
    
    override func testPaging() {
        openScreen()
        
        // load next page in online
        super.testPaging()
        
        // scroll to up
        for _ in 1...11 {
            app.swipeDown()
        }
        makePullToRefreshWithoutReachability(with: followersFeed.getItem(at: 0).cell)
        
        // test offline pagination
        super.testPaging()
    }
    
}
