//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ActivityServiceMock: ActivityServiceProtocol {
    
    var mockedResult: Result<ActivityView>!
    
    func loadPendings(cursor: String?, limit: Int, completion: (String) -> Void) {
        completion("loliki")
    }
    
    func loadActions(cursor: String?, limit: Int, completion: (Result<ActivityView>) -> Void) {
    
        completion(mockedResult)
        
    }
}

class ActivityInteractorTests: XCTestCase {
    
    var sut: ActivityInteractor!
    var service: ActivityServiceMock!
    
    override func setUp() {
        super.setUp()
        
        sut = ActivityInteractor()
        service = ActivityServiceMock()
        sut.service = service
        
    }
    
    func testItMapsActionItem_WithBasicResponse() {
        
        // given
        let response = ActivityView()
        
        let actors: [UserCompactView] = [("Bilya", "Atos"), ("Dog", "Egg")].map {
            let actor: UserCompactView = UserCompactView()
            actor.firstName = $0.0
            actor.lastName = $0.1
            return actor
        }
        
        let actedOnUser = UserCompactView()
        actedOnUser.firstName = "Stivi"
        actedOnUser.lastName = "Hopes"
        response.activityType = .like
        response.actorUsers = actors
        response.actedOnUser = actedOnUser
        
        service.mockedResult = Result(value: response, error: nil)
        
        // when
        let e = expectation(description: #file)
        sut.load { (result: Result<ActionItem>) in
            
            // then
            guard let actionItem = result.value else { return }
            XCTAssertTrue(actionItem.actedOnName == response.actedOnUser?.firstName)
           
            for (index, actor) in actionItem.actorNameList.enumerated() {
                XCTAssertTrue(actor.firstName == actors[index].firstName)
                XCTAssertTrue(actor.lastName == actors[index].lastName)
            }
            
            XCTAssertTrue(actionItem.type.rawValue == response.activityType?.rawValue)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testItMapsActionItem_WithBadResponse() {
        
        // given
        let response = ActivityView()
        service.mockedResult = Result(value: response, error: nil)
        let e = expectation(description: #file)
        
        // when
        sut.load { (result: Result<ActionItem>) in
            
            XCTAssertTrue(result.isFailure)
            guard let error = result.error as? ModuleError else { return }
            XCTAssertTrue(error == ModuleError.mapperNotFound)
            e.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
