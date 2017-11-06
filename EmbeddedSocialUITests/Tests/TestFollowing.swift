//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestFollowingOnline: TestFollowersOnline {
    
    override func setUp() {
        super.setUp()
        
        feedName = "User Following"
        feedHandle = "UserFollowing"
    }
    
    override func openScreen() {
        navigate(to: .userProfile)
        profile.followingButton.tap()
    }
    
}

class TestFollowingOffline: TestFollowersOffline {
    
    override func setUp() {
        super.setUp()
        
        feedName = "User Following"
        feedHandle = "UserFollowing"
    }
    
    override func openScreen() {
        navigate(to: .userProfile)
        profile.followingButton.tap()
    }
    
}
