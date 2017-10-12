//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TestMyPins: TestOnlineHome {
    
    override func setUp() {
        super.setUp()
        
        feedName = "pins"
        serviceName = "pins"
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .myPins)
    }
    
    override func testFeedSource() {
        super.testFeedSource()
    }
    
    override func testPostAttributes() {
        super.testPostAttributes()
    }
    
    override func testLikePost() {
        super.testLikePost()
    }
    
    override func testPinPostButton() {
        openScreen()
        
        let (index, post) = feed.getRandomPost()
        
        post.pin()
        
        XCTAssertNotNil(APIState.getLatestRequest().hasSuffix("users/me/pins/\(feedName + String(index))"))
        XCTAssert(!post.pinButton.isSelected, "Post is marking as pinned yet")
        
        post.pin()
        
        let request = APIState.getLatestData(forService: serviceName)
        
        XCTAssertEqual(request?["topicHandle"] as! String, feedName + String(index))
        XCTAssert(post.pinButton.isSelected, "Post is marking as unpinned yet")
    }
    
    override func testPaging() {
        super.testPaging()
    }
    
    override func testPullToRefresh() {
        super.testPullToRefresh()
    }
    
    override func testPostImagesLoaded() {
        super.testPostImagesLoaded()
    }
    
    override func testOpenPostDetails() {
        super.testOpenPostDetails()
    }
    
    override func testPagingTileMode() {
        super.testPagingTileMode()
    }
    
    override func testPostImagesLoadedTileMode() {
        super.testPostImagesLoadedTileMode()
    }
    
    override func testPullToRefreshTileMode() {
        super.testPullToRefreshTileMode()
    }
    
    override func testOpenPostDetailsTileMode() {
        super.testOpenPostDetailsTileMode()
    }
    
}
