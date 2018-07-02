//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestUserProfile: BaseFeedTest {
    
    private var userName: String!
    
    var userHandle: String!
    var profile: UserProfile!
    
    override func setUp() {
        super.setUp()
        
        userName = "John Doe"
        userHandle = "OtherUser"
        
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        feed.getRandomItem().1.getLabelByText(userName).tapByCoordinate()
    }
    
    func testProfileAttributes() {
        XCTAssert(profile.textExists("Alan Poe"), "Username doesn't match")
        XCTAssert(profile.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "User bio doesn't match")
        XCTAssertEqual(profile.followersButton.label, "5 followers", "Number of followers doesn't match")
        XCTAssertEqual(profile.followingButton.label, "7 following", "Number of following doesn't match")
        XCTAssertEqual(profile.followButton.label, "FOLLOWING", "User is not marked as following")
    }
    
    func testFollowUser() {
        profile.follow()
        checkIsUserFollowed()
        
        profile.follow()
        checkIsUserUnfollowed()
    }
    
    func checkIsUserFollowed() {
        XCTAssertEqual(profile.followButton.label, "FOLLOWING", "User is not marked as following")
        XCTAssertEqual(profile.followersButton.label, "1 followers")
    }
    
    func checkIsUserUnfollowed() {
        XCTAssertEqual(profile.followButton.label, "FOLLOW", "User is marked as following")
        XCTAssertEqual(profile.followersButton.label, "0 followers")
    }
    
}

class TestUserProfileOnline: BaseTestUserProfile, OnlineTest {
    
    override func testProfileAttributes() {
        APIConfig.values = ["firstName": "Alan",
                            "lastName": "Poe",
                            "bio": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "totalFollowers": 5,
                            "totalFollowing": 7,
                            "followerStatus": "Follow"]
        
        openScreen()
        super.testProfileAttributes()
    }
    
    override func testFollowUser() {
        openScreen()
        super.testFollowUser()
    }
    
    override func checkIsUserFollowed() {
        let request = APIState.getLatestData(forService: "followers")
        XCTAssertEqual(request?["userHandle"] as! String, userHandle)
        super.checkIsUserFollowed()
    }
    
    override func checkIsUserUnfollowed() {
        XCTAssertTrue(APIState.getLatestRequest().contains("users/me/following/users/" + userHandle))
        super.checkIsUserUnfollowed()
    }
    
}

class TestUserProfileOffline: BaseTestUserProfile, OfflineTest {
    
    override func testProfileAttributes() {
        APIConfig.values = ["firstName": "Alan",
                            "lastName": "Poe",
                            "bio": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "totalFollowers": 5,
                            "totalFollowing": 7,
                            "followerStatus": "Follow"]
        
        openScreen()
        makePullToRefreshWithoutReachability(with: profile.asUIElement())
        super.testProfileAttributes()
    }
    
    override func testFollowUser() {
        openScreen()
        makePullToRefreshWithoutReachability(with: profile.asUIElement())
        super.testFollowUser()
    }
    
}

class TestUserProfileRecentPostsOnline: TestOnlineHome {
    
    private var userName: String!
    
    override func setUp() {
        super.setUp()
        userName = "John Doe"
    }
    
    override func openScreen() {
        feed.getRandomItem().1.getLabelByText(userName).tapByCoordinate()
        UserProfile(app).recentPostsButton.tap()
        
        feed = Feed(app, switchViewModeButton: app.navigationBars.buttons.element(boundBy: 2))
    }
    
}

class TestUserProfileRecentPostsOffline: TestOfflineHome {
    
    private var userName: String!
    
    override func setUp() {
        super.setUp()
        userName = "John Doe"
    }
    
    override func openScreen() {
        feed.getRandomItem().1.getLabelByText(userName).tapByCoordinate()
        UserProfile(app).recentPostsButton.tap()
        
        feed = Feed(app, switchViewModeButton: app.navigationBars.buttons.element(boundBy: 2))
    }
    
}

class TestUserProfilePopularPostsOnline: TestOnlineHome {
    
    private var userName: String!
    
    override func setUp() {
        super.setUp()
        userName = "John Doe"
    }
    
    override func openScreen() {
        feed.getRandomItem().1.getLabelByText(userName).tapByCoordinate()
        UserProfile(app).popularPostsButton.tap()
        
        feed = Feed(app, switchViewModeButton: app.navigationBars.buttons.element(boundBy: 2))
    }
    
}

class TestUserProfilePopularPostsOffline: TestOfflineHome {
    
    private var userName: String!
    
    override func setUp() {
        super.setUp()
        userName = "John Doe"
    }
    
    override func openScreen() {
        feed.getRandomItem().1.getLabelByText(userName).tapByCoordinate()
        UserProfile(app).popularPostsButton.tap()
        
        feed = Feed(app, switchViewModeButton: app.navigationBars.buttons.element(boundBy: 2))
    }
    
}
