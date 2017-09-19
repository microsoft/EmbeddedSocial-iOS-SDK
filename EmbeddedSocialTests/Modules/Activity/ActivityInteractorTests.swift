//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ActivityServiceMock: ActivityServiceProtocol {
    
    func loadActions(cursor: String?, limit: Int, completion: (Result<FeedResponseActivityView>) -> Void) {
        completion(mockedResult)
    }

    var mockedResult: Result<FeedResponseActivityView>!
    
    func loadPendings(cursor: String?, limit: Int, completion: (String) -> Void) {
        completion("loliki")
    }

}

class ActivityInteractorTests: XCTestCase {
    
    var sut: ActivityInteractor!
    var service: ActivityServiceMock!
    var response: FeedResponseActivityView!
    
    override func setUp() {
        super.setUp()
        
        sut = ActivityInteractor()
        service = ActivityServiceMock()
        sut.service = service
        response = loadResponse(from: "myActivity")
    }
    
    override func tearDown() {
        service = nil
        sut = nil
        response = nil
        super.tearDown()
    }
    
    func testItMapsActionItem_WithBasicResponse() {
        
        // given
        service.mockedResult = Result(value: response, error: nil)
        
        // when
        let e = expectation(description: #file)
        sut.load { (result: ItemFetchResult<ActionItem>) in
            
            // then
            guard let actionItem = result.items?.first else { return }
            
//            XCTAssertTrue(actionItem.actedOnName == activity.actedOnUser?.firstName)
           
            for (index, actor) in actionItem.actorNameList.enumerated() {
//                XCTAssertTrue(actor.firstName == actors[index].firstName)
//                XCTAssertTrue(actor.lastName == actors[index].lastName)
            }
            
//            XCTAssertTrue(actionItem.type.rawValue == activity.activityType?.rawValue)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testItMapsActionItem_WithBadResponse() {
        
        // given
        service.mockedResult = Result(value: response, error: nil)
        let e = expectation(description: #file)
        
        // when
        sut.load { (result: ItemFetchResult<ActionItem>) in
            
            XCTAssertTrue(result.error == ModuleError.mapperNotFound)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
