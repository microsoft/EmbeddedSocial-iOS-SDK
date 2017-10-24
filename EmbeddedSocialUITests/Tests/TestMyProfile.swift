//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestProfileDetails: BaseSideMenuTest {
    
    var profile: UserProfile!
    
    override func setUp() {
        super.setUp()
        profile = UserProfile(app)
    }
    
    func openProfileScreen() {
        setupUserProfileAttributes()
        navigate(to: .userProfile)
    }
    
    func testProfileAttributes() {
        XCTAssert(profile.textExists("Alan Poe"), "Username doesn't match")
        XCTAssert(profile.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "User bio doesn't match")
        XCTAssertEqual(profile.followersButton.label, "5 followers", "Number of followers doesn't match")
        XCTAssertEqual(profile.followingButton.label, "7 following", "Number of following doesn't match")
    }
    
    private func setupUserProfileAttributes() {
        APIConfig.values = ["firstName": "Alan",
                            "lastName": "Poe",
                            "bio": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "totalFollowers": 5,
                            "totalFollowing": 7]
    }
    
}

class TestOnlineProfileDetails: BaseTestProfileDetails, OnlineTest {
    
    override func testProfileAttributes() {
        openProfileScreen()
        super.testProfileAttributes()
    }
    
}

class TestOfflineProfileDetails: BaseTestProfileDetails, OfflineTest {
    
    override func testProfileAttributes() {
        openProfileScreen()
        makePullToRefreshWithoutReachability(with: profile.details)
        super.testProfileAttributes()
    }
    
}

class TestMyProfileRecentPosts: TestOnlineHome {
    var profile: UserProfile!
    
    override func setUp() {
        super.setUp()
        feedName = "me"
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
        profile.recentPostsButton.tap()
        sleep(1)
    }
    
}

class TestMyProfilePopularPosts: TestOnlineHome {
    var profile: UserProfile!

    override func setUp() {
        super.setUp()
        feedName = "mepopular"
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
        profile.popularPostsButton.tap()
        sleep(1)
    }
    
}
