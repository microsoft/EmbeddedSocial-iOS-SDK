//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestActivityFeed: TestHome {
    
    private var activitySegment: ActivityFeedSegment!
    
    override func setUp() {
        super.setUp()
        
        pageSize = 20
        activitySegment = ActivityFeedSegment(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .activityFeed)
    }
    
    func selectSegment(item: ActivityFeedSegmentItem) {
        activitySegment.select(item: item)
    }
    
    func makePullToRefresh(for element: XCUIElement) {
        let startTouchPosition = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finishTouchPosition = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
        startTouchPosition.press(forDuration: 0, thenDragTo: finishTouchPosition)
    }
    
}

class TestYourActivityFeed: BaseTestActivityFeed {
    
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
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"))
    }
    
    func testPendingRequestPaging() {
        openScreen()
        
        // move to the last item
        let _ = activityFollowRequests.getRequestItem(at: activityFollowRequests.getRequestsCount() - 1)
        app.swipeUp()
        
        let latestRequest = APIState.getLatestResponse(forService: "pendingUsers")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
    func testRecentActivityPaging() {
        openScreen()
        
        recentActivities.offset = activityFollowRequests.getRequestsCount()
        
        // move to the last item
        let _ = recentActivities.getActivityItem(at: recentActivities.getActivitiesCount() - 1)
        app.swipeUp()
        
        let latestRequest = APIState.getLatestResponse(forService: "notifications")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
    override func testPullToRefresh() {
        openScreen()
        
        for _ in 0...5 {
            app.swipeUp()
        }
        
        for _ in 0...5 {
            app.swipeDown()
        }
        
        makePullToRefresh(for: activityFollowRequests.getRequestItem(at: 0).asUIElement())
        
        let latestPendingUsersResponse = APIState.getLatestResponse(forService: "pendingUsers")
        let latestRecentActivitiesResponse = APIState.getLatestResponse(forService: "notifications")
        
        XCTAssertNotNil(latestPendingUsersResponse)
        XCTAssertNotNil(latestRecentActivitiesResponse)
        
        XCTAssertEqual(latestPendingUsersResponse!["cursor"] as! String, String(pageSize), "First page for pending users not loaded")
        XCTAssertEqual(latestRecentActivitiesResponse!["cursor"] as! String, String(pageSize), "First page for recent activities not loaded")
    }
    
    func testPendingRequestAttributes() {
        openScreen()
        
        let (requestIndex, requestItem) = activityFollowRequests.getRandomRequestItem()
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists(text: "Pending Request\(requestIndex)"))
    }
    
    func testPendingRequestAccepting() {
        openScreen()
        
        let (requestIndex, requestItem) = activityFollowRequests.getRandomRequestItem()
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists(text: "Pending Request\(requestIndex)"))
        
        let beforeAcceptingRequestsCount = activityFollowRequests.getRequestsCount()
        requestItem.accept()
        
        let acceptUserHandleResponse = APIState.getLatestData(forService: "followers")?["userHandle"] as? String
        XCTAssertTrue((beforeAcceptingRequestsCount - 1) == activityFollowRequests.getRequestsCount())
        XCTAssertTrue(APIState.getLatestRequest().contains("/me/followers"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        XCTAssertEqual(acceptUserHandleResponse, "PendingRequest\(requestIndex)")
    }
    
    func testPendingRequestDeclining() {
        openScreen()
        
        let (requestIndex, requestItem) = activityFollowRequests.getRandomRequestItem()
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists(text: "Pending Request\(requestIndex)"))
        
        let beforeDecliningRequestsCount = activityFollowRequests.getRequestsCount()
        requestItem.decline()
        
        XCTAssertTrue((beforeDecliningRequestsCount - 1) == activityFollowRequests.getRequestsCount())
        XCTAssertTrue(APIState.getLatestRequest().contains("/me/pending_users/PendingRequest\(requestIndex)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
    }
    
}

class TestFollowingActivityFeed: BaseTestActivityFeed {
    
    private var recentActivities: RecentActivity!
    
    override func setUp() {
        super.setUp()
        
        recentActivities = RecentActivity(app)
    }
    
    override func openScreen() {
        super.openScreen()
        selectSegment(item: .following)
    }
    
    func testItemAttributes() {
        
    }
    
    func testImagesLoading() {
        APIConfig.showUserImages = true
        
        openScreen()
        selectSegment(item: .following)
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"))
    }
    
    override func testPaging() {
        openScreen()
        
        // move to the last item
        let _ = recentActivities.getActivityItem(at: recentActivities.getActivitiesCount() - 1)
        app.swipeUp()
        
        let latestRequest = APIState.getLatestResponse(forService: "activities")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
    override func testPullToRefresh() {
        openScreen()
        
        for _ in 0...5 {
            app.swipeUp()
        }
        
        for _ in 0...5 {
            app.swipeDown()
        }
        
        makePullToRefresh(for: recentActivities.getActivityItem(at: 0).asUIElement())
        
        let latestResponse = APIState.getLatestResponse(forService: "activities")
        XCTAssertNotNil(latestResponse)
        XCTAssertEqual(latestResponse!["cursor"] as! String, String(pageSize), "First page not loaded")
    }
    
}
