//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BaseTestActivityFeed: BaseSideMenuTest {
    
    var pageSize: Int!
    
    private var activitySegment: ActivityFeedSegment!
    
    override func setUp() {
        super.setUp()
        
        pageSize = 20
        activitySegment = ActivityFeedSegment(app)
    }
    
    override func openScreen() {
        sideMenu.navigate(to: .activityFeed)
        sleep(1)
    }
    
    func selectSegment(item: ActivityFeedSegmentItem) {
        activitySegment.select(item: item)
        sleep(1)
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
        let _ = activityFollowRequests.getItem(at: activityFollowRequests.getItemsCount() - 1)
        app.swipeUp()
        
        let latestRequest = APIState.getLatestResponse(forService: "pendingUsers")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
    func testRecentActivityPaging() {
        openScreen()
        
        // move to the last item
        let _ = recentActivities.getItem(at: recentActivities.getItemsCount() - 1)
        app.swipeUp()
        
        let latestRequest = APIState.getLatestResponse(forService: "notifications")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
    func testPaging() {
        openScreen()
        
        let currentFollowRequestsCount = activityFollowRequests.getItemsCount()
        let currentActivitiesCount = recentActivities.getItemsCount()
        
        for _ in 0...20 {
            app.swipeUp()
        }
        
        // get new list size
        let newFollowRequestsCount = activityFollowRequests.getItemsCount()
        let newActivitiesCount = recentActivities.getItemsCount()
        
        XCTAssertGreaterThan(newFollowRequestsCount, currentFollowRequestsCount)
        XCTAssertGreaterThan(newActivitiesCount, currentActivitiesCount)
        
        let latestFollowersRequest = APIState.getLatestResponse(forService: "pendingUsers")
        XCTAssertNotNil(latestFollowersRequest)
        XCTAssertGreaterThan(latestFollowersRequest!["cursor"] as! String, String(pageSize))
        
        let latestActivitiesRequest = APIState.getLatestResponse(forService: "notifications")
        XCTAssertNotNil(latestActivitiesRequest)
        XCTAssertGreaterThan(latestActivitiesRequest!["cursor"] as! String, String(pageSize))
    }
    
    func testPullToRefresh() {
        openScreen()
        
        for _ in 0...5 {
            app.swipeUp()
        }
        
        for _ in 0...5 {
            app.swipeDown()
        }
        
        makePullToRefresh(for: activityFollowRequests.asUIElement())
        
        let latestPendingUsersResponse = APIState.getLatestResponse(forService: "pendingUsers")
        let latestRecentActivitiesResponse = APIState.getLatestResponse(forService: "notifications")
        
        XCTAssertNotNil(latestPendingUsersResponse)
        XCTAssertNotNil(latestRecentActivitiesResponse)
        
        XCTAssertGreaterThanOrEqual(latestPendingUsersResponse!["cursor"] as! String, String(pageSize), "First page for pending users not loaded")
        XCTAssertGreaterThanOrEqual(latestRecentActivitiesResponse!["cursor"] as! String, String(pageSize), "First page for recent activities not loaded")
    }
    
    func testPendingRequestAttributes() {
        openScreen()
        
        let (requestIndex, requestItem) = activityFollowRequests.getRandomItem()
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists("Pending Request\(requestIndex)"))
    }
    
    func testPendingRequestAccepting() {
        openScreen()
        
        let (requestIndex, requestItem) = activityFollowRequests.getRandomItem()
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists("Pending Request\(requestIndex)"))
        
        let beforeAcceptingRequestsCount = activityFollowRequests.getItemsCount()
        requestItem.accept()
        
        let acceptUserHandleResponse = APIState.getLatestData(forService: "followers")?["userHandle"] as? String
        XCTAssertTrue(APIState.getLatestRequest().contains("/me/followers"))
        XCTAssertTrue(APIState.latestRequstMethod == "POST")
        XCTAssertEqual(acceptUserHandleResponse, "PendingRequest\(requestIndex)")
        XCTAssertTrue((beforeAcceptingRequestsCount - 1) == activityFollowRequests.getItemsCount())
    }
    
    func testPendingRequestDeclining() {
        openScreen()
        
        let (requestIndex, requestItem) = activityFollowRequests.getRandomItem()
        
        XCTAssertNotNil(requestItem)
        XCTAssertTrue(requestItem.isExists("Pending Request\(requestIndex)"))
        
        let beforeDecliningRequestsCount = activityFollowRequests.getItemsCount()
        requestItem.decline()
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/me/pending_users/PendingRequest\(requestIndex)"))
        XCTAssertTrue(APIState.latestRequstMethod == "DELETE")
        XCTAssertTrue((beforeDecliningRequestsCount - 1) == activityFollowRequests.getItemsCount())
    }
    
}

class TestFollowingActivityFeed: BaseTestActivityFeed {
    private let contentTypes = ["Comment",
                                "Topic",
                                "Reply",
                                "User"]
    
    private let activityTypes = ["Like",
                                 "Like",
                                 "Like",
                                 "Following"]
    
    private let activityTypeResults = ["liked comment",
                                       "liked topic",
                                       "liked reply",
                                       "started following"]
    
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
        openScreen()
        
        for i in 0..<activityTypes.count {
            let actedOnContent = contentTypes[i]
            let activityType = activityTypes[i]
            
            APIConfig.values = ["activityType" : activityType,
                                "actedOnContent->contentType" : actedOnContent]
            makePullToRefresh(for: recentActivities.asUIElement())
            
            let index: UInt = 0
            let activityItem = recentActivities.getItem(at: index, withScroll: false)
            
            let expectedResult = activityTypeResults[i]
            XCTAssertTrue(activityItem.isExists(expectedResult))
        }
    }
    
    func testImagesLoading() {
        APIConfig.showUserImages = true
        
        openScreen()
        
        XCTAssertTrue(APIState.getLatestRequest().contains("/images/"))
    }
    
    func testPaging() {
        openScreen()

        var retryCount = 10
        
        while recentActivities.getItemsCount() <= UInt(pageSize) && retryCount != 0 {
            retryCount -= 1
            app.swipeUp()
        }
        
        let latestRequest = APIState.getLatestResponse(forService: "activities")
        XCTAssertNotNil(latestRequest)
        XCTAssertGreaterThan(latestRequest!["cursor"] as! String, String(pageSize))
    }
    
    func testPullToRefresh() {
        openScreen()
        
        for _ in 0...5 {
            app.swipeUp()
        }
        
        for _ in 0...5 {
            app.swipeDown()
        }
        
        makePullToRefresh(for: recentActivities.getItem(at: 0).asUIElement())
        
        let latestResponse = APIState.getLatestResponse(forService: "activities")
        XCTAssertNotNil(latestResponse)
        XCTAssertGreaterThanOrEqual(latestResponse!["cursor"] as! String, String(pageSize), "First page not loaded")
    }
    
}
