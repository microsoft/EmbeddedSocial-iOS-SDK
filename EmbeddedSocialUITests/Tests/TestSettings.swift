//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestSettings: TestHome {
    
    var onlyFollowersCanSeeMyPostsSwitch: XCUIElement!
    
    override func openScreen() {
        sideMenu.navigate(to: .settings)
    }
    
    func testSwitch() {
        openScreen()
        
        onlyFollowersCanSeeMyPostsSwitch = app.switches.element(boundBy: 0)
        
        // check ON state
        onlyFollowersCanSeeMyPostsSwitch.tap()
        let latestRequest = APIState.getLatestRequest()
        XCTAssert(latestRequest.contains("/visibility"), "Error")
    }
    
}
