//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestMyPostMenu: TestHome {
    
    override func setUp() {
        super.setUp()
    }
    
    override func openScreen() {
        sideMenu.navigateToUserProfile()
    }
    
    func testPostRemoving() {
        setupCurrentUserCredentialsForTopics()
        
        openScreen()
        
        let (postIndex, postItem) = feed.getRandomPost()
        XCTAssertTrue(postItem.menu().isExists(item: .remove))
        postItem.menu().select(item: .remove)
        
        XCTAssertEqual(APIState.latestRequstMethod, "DELETE")
        XCTAssertTrue(APIState.getLatestRequest().hasSuffix("/topics/me\(postIndex)"))
    }
    
}

extension TestMyPostMenu {
    
    fileprivate func setupCurrentUserCredentialsForTopics() {
        APIConfig.values = ["user->userHandle" : "JohnDoe"]
    }
    
}
