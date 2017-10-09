//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class TestFollowing: TestFollowers {
    
    override func setUp() {
        super.setUp()
        feedName = "User Following"
        feedHandle = "UserFollowing"
    }
    
    override func openScreen() {
        menu.navigateToUserProfile()
        profile.followingButton.tap()
        sleep(1)
    }
}
