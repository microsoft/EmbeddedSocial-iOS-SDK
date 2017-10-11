//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestUserProfile: UITestBase {
    var sideMenu: SideMenu!
    var profile: UserProfile!
    var feed: Feed!
    var userName: String!
    var userHandle: String!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        profile = UserProfile(app)
        feed = Feed(app)
        userName = "John Doe"
        userHandle = "JohnDoe"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func openScreen() {
        sideMenu.navigate(to: .home)
        let (_, post) = feed.getRandomPost()
        post.getLabelByText(userName).tapByCoordinate()
        sleep(1)
    }
    
    func testProfileAttributes() {
        APIConfig.values = ["firstName": "Alan",
                            "lastName": "Poe",
                            "bio": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "totalFollowers": 5,
                            "totalFollowing": 7,
                            "followerStatus": "Follow"]
        
        openScreen()
        
        XCTAssert(profile.textExists("Alan Poe"), "Username doesn't match")
        XCTAssert(profile.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "User bio doesn't match")
        XCTAssertEqual(profile.followersButton.label, "5 followers", "Number of followers doesn't match")
        XCTAssertEqual(profile.followingButton.label, "7 following", "Number of following doesn't match")
        XCTAssertEqual(profile.followButton.label, "FOLLOWING", "User is not marked as following")
        
        APIConfig.values = ["followerStatus": "Blocked"]
        
        profile.back()
        openScreen()
        
        XCTAssertEqual(profile.followButton.label, "BLOCKED", "User is not marked as blocked")
    }
    
    func testFollowUser() {
        openScreen()
        
        profile.followButton.tap()
        
        let request = APIState.getLatestData(forService: "followers")
        
        XCTAssertEqual(request?["userHandle"] as! String, userHandle)
        XCTAssertEqual(profile.followButton.label, "FOLLOWING", "User is not marked as following")
        XCTAssertEqual(profile.followersButton.label, "1 followers")
        
        profile.follow()
        
        XCTAssertNotNil(APIState.getLatestRequest().contains("users/me/following/users/" + userHandle))
        XCTAssertEqual(profile.followButton.label, "FOLLOW", "User is marked as following")
        XCTAssertEqual(profile.followersButton.label, "0 followers")
    }
}


class TestUserProfileRecentPosts: TestOnlineHome, OnlineTest {
    var profile: UserProfile!
    var userName: String!
    
    override func setUp() {
        super.setUp()
        userName = "John Doe"
        feedName = "JohnDoe"
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .home)
        let (_, post) = feed.getRandomPost()
        if !post.getLabelByText(userName).exists {
            userName = "Alan Poe"
        }
        post.getLabelByText(userName).tapByCoordinate()
        profile.recentPostsButton.tap()
        sleep(1)
    }
    
}

class TestUserProfilePopularPosts: TestOnlineHome, OnlineTest {
    var profile: UserProfile!
    var userName: String!
    
    override func setUp() {
        super.setUp()
        userName = "John Doe"
        feedName = "JohnDoepopular"
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .home)
        let (_, post) = feed.getRandomPost()
        if !post.getLabelByText(userName).exists {
            userName = "Alan Poe"
        }
        post.getLabelByText(userName).tapByCoordinate()
        profile.popularPostsButton.tap()
        sleep(1)
    }
    
}
