//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestActivityFeed: TestHome {
    
    private var activitySegment: ActivityFeedSegment!
    
    override func setUp() {
        super.setUp()
        
        activitySegment = ActivityFeedSegment(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .activityFeed)
    }
    
    func selectSegment(item: ActivityFeedSegmentItem) {
        activitySegment.select(item: item)
    }
    
}

class TestYouActivityFeed: BaseTestActivityFeed {
    
    private var activityFollowRequests: ActivityFollowRequests!
    private var recentActivities: RecentActivity!
    
    override func setUp() {
        super.setUp()
        
        activityFollowRequests = ActivityFollowRequests(app)
        recentActivities = RecentActivity(app)
    }
    
    func testProfilesImagesLoading() {
        APIConfig.showUserImages = true
        
        openScreen()
        sleep(2)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"))
    }
    
    func testPendingRequestAccepting() {
        openScreen()
        
//        let (requestIndex, requestItem) = activityFollowRequests.getRandomRequestItem()
        
        let requestIndex: Uint = 1
        let requestItem = activityFollowRequests.getRequestItem(at: requestIndex)
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists(text: "Name LastName #\(requestIndex)"))
        
        let beforeAcceptingRequestsCount = activityFollowRequests.getRequestsCount()
        APIConfig.values = ["userHandle" : "Name LastName #\(requestIndex)"]
        requestItem.accept()
        
        let acceptUserHandleResponse = APIState.getLatestResponse(forService: "followers")?["userHandle"] as? String
        XCTAssertTrue((beforeAcceptingRequestsCount - 1) == activityFollowRequests.getRequestsCount())
        XCTAssertTrue(APIState.getLatestRequest().contains("/me/followers"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        XCTAssertNotNil(acceptUserHandleResponse == "Name LastName #\(requestIndex)")
    }
    
    func testPendingRequestDeclining() {
        openScreen()
        
        //        let (requestIndex, requestItem) = activityFollowRequests.getRandomRequestItem()
        
        let requestIndex: Uint = 1
        let requestItem = activityFollowRequests.getRequestItem(at: requestIndex)
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists(text: "Name LastName #\(requestIndex)"))
        
        let beforeDecliningRequestsCount = activityFollowRequests.getRequestsCount()
        requestItem.decline()
        
        XCTAssertTrue((beforeDecliningRequestsCount - 1) == activityFollowRequests.getRequestsCount())
        XCTAssertTrue(APIState.getLatestRequest().contains("/me/pending_users/"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
}

class TestFollowingActivityFeed: BaseTestActivityFeed {
    
    private var recentActivities: RecentActivity!
    
    override func setUp() {
        super.setUp()
        
        recentActivities = RecentActivity(app)
    }
    
    func testImagesLoading() {
        APIConfig.showUserImages = true
        
        openScreen()
        selectSegment(item: .following)
        sleep(2)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"))
    }
    
}
