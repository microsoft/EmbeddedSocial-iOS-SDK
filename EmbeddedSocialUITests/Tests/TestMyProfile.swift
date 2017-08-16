//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestMyProfile: UITestBase {
    var sideMenu: SideMenu!
    var profile: UserProfile!
    
    override func setUp() {
        super.setUp()
        sideMenu = SideMenu(app)
        profile = UserProfile(app)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func openScreen() {
        sideMenu.navigateToUserProfile()
    }
    
    func testProfileAttributes() {
        APIConfig.values = ["firstName": "Alan",
                            "lastName": "Poe",
                            "bio": "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            "totalFollowers": 5,
                            "totalFollowing": 7]
        
        openScreen()
        
        XCTAssert(profile.textExists("Alan Poe"), "Username doesn't match")
        XCTAssert(profile.textExists("Lorem ipsum dolor sit amet, consectetur adipiscing elit."), "User bio doesn't match")
        XCTAssertEqual(profile.followersButton.label, "5 followers", "Number of followers doesn't match")
        XCTAssertEqual(profile.followingButton.label, "7 following", "Number of following doesn't match")
    }
}

class TestMyProfileRecentPosts: TestHome {
    var profile: UserProfile!
    
    override func setUp() {
        super.setUp()
        feedName = "UserHandle"
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
        profile.recentPostsButton.tap()
        sleep(1)
    }
    
}

class TestMyProfilePopularPosts: TestHome {
    var profile: UserProfile!

    override func setUp() {
        super.setUp()
        feedName = "UserHandlepopular"
        profile = UserProfile(app)
    }
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
        profile.popularPostsButton.tap()
        sleep(1)
    }
    
}
