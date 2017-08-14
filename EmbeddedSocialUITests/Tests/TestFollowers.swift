//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestFollowers: UITestBase {
    var menu: SideMenu!
    var profile: UserProfile!
    var followers: FollowersFeed!
    var feedName: String!
    var feedHandle: String!
    var pageSize: Int!
    
    override func setUp() {
        super.setUp()
        menu = SideMenu(app)
        profile = UserProfile(app)
        followers = FollowersFeed(app)
        feedName = "User Follower"
        feedHandle = "UserFollower"
        pageSize = 30
    }
    
    override func tearDown() {
        super.tearDown()
        APIConfig.showUserImages = false
    }
    
    func openScreen() {
        menu.navigateToUserProfile()
        profile.followersButton.tap()
        sleep(1)
    }
    
    func testFeedSource() {
        openScreen()
        
        let (index, follower) = followers.getRandomFollower()
        
        XCTAssert(follower.textExists(feedName + String(index)), "Incorrect feed source")
    }
    
    func testUserListAttributes() {
        APIConfig.values = ["followerStatus": "Follow"]
        
        openScreen()
        
        let (index, follower) = followers.getRandomFollower()
        
        XCTAssert(follower.textExists(feedName + String(index)), "User names don't match")
        XCTAssertEqual(follower.followButton.label, "FOLLOWING", "Users are not marked as following")
        
        APIConfig.values = ["followerStatus": "Blocked"]
        
        followers.back()
        openScreen()

        XCTAssertEqual(follower.followButton.label, "BLOCKED", "Users are not marked as blocked")
    }
    
    func testFollowUser() {
        openScreen()
        
        let (index, follower) = followers.getRandomFollower()
        
        follower.follow()
        
        let request = APIState.getLatestData(forService: "followers")
        
        XCTAssertEqual(request?["userHandle"] as! String, feedHandle + String(index))
        XCTAssert(follower.followButton.isSelected, "User is not marked as following")
        XCTAssertEqual(follower.followButton.label, "FOLLOWING", "User is not marked as following")
        
        follower.follow()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/following/users/" + feedHandle + String(index)))
        XCTAssert(follower.followButton.isSelected, "User is marked as following")
        XCTAssertEqual(follower.followButton.label, "FOLLOW", "User is marked as following")
    }
    
    func testPaging() {
        openScreen()
        
        var retryCount = 10
        
        while followers.getFollowersCount() <= UInt(pageSize) && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
        
        XCTAssertGreaterThan(followers.getFollowersCount(), UInt(pageSize), "New users weren't loaded while swiping feed up")
    }
    
    func testUserImagesLoaded() {
        APIConfig.showUserImages = true
        
        openScreen()
        
        sleep(2) //Wait until images loaded
        
        XCTAssertNotNil(XCTAssertNotNil(APIState.getLatestRequest().contains("/images/")), "Post images weren't loaded")
    }
    
}
