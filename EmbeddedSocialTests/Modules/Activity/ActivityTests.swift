//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ActivityEntitiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testService() {
        
        // given
        

        
//        let _: RequestBuilder<FeedResponseUserCompactView>? = service.builder(cursor: "safa", limit: 10)
    }
    
    func testThatServiceProducesResponse() {
        
        let service = ActivityServiceMock()
        let response = buildActivitiResponseMock()
        service.followingActivitiesResponse = .success(response)
        
        let e = expectation(description: #file)
        
        service.loadFollowingActivities(cursor: "", limit: 10) { (result: Result<FeedResponseActivityView> ) in
            XCTAssertTrue(result.isSuccess)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testThatInteractorFetchesResult() {
        
        // given
        let service = ActivityServiceMock()
        let pendingRequestsResponse = buildPendingRequestsResponseMock()
        let followingActivitiesResponse = buildActivitiResponseMock()
        service.pendingRequestsResponse = .success(pendingRequestsResponse)
        service.followingActivitiesResponse = .success(followingActivitiesResponse)
        
        let interactor = ActivityInteractor()
        interactor.service = service
        
        let pendingRequests = expectation(description: #file)
        
        // when #1
        interactor.loadNextPagePendigRequestItems { (result) in
            
            // then #1
            guard let items = result.value else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(items.count == pendingRequestsResponse.data?.count)
            pendingRequests.fulfill()
        }
        
        let followingActivities = expectation(description: #file)
        
        // when #2
        interactor.loadNextPageMyActivities { (result) in
            
            // then #2
            guard let items = result.value else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(items.count == followingActivitiesResponse.data?.count)
            followingActivities.fulfill()
        }
        
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testThatPaggingWorksCorrectly() {
        
        // given
        let service = ActivityServiceMock()
        let followingActivitiesResponse = buildActivitiResponseMock()
        service.followingActivitiesResponse = .success(followingActivitiesResponse)
        
        let interactor = ActivityInteractor()
        interactor.service = service
        
        let pendingRequests = expectation(description: #file)
        
        // when
        
//        interactor.
        
        // then
    }
    
    func buildActivitiResponseMock() -> FeedResponseActivityView {
        return FeedResponseActivityView().mockResponse()
    }
    
    func buildPendingRequestsResponseMock() -> FeedResponseUserCompactView {
        return FeedResponseUserCompactView().mockResponse()
    }
    

}
