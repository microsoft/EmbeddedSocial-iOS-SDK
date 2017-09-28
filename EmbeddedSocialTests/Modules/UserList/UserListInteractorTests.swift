//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserListInteractorTests: XCTestCase {
    var socialService: MockSocialService!
    var listProcessor: MockUsersListProcessor!
    var sut: UserListInteractor!
    var output: MockUserListInteractorOutput!
    
    private let timeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        socialService = MockSocialService()
        listProcessor = MockUsersListProcessor()
        output = MockUserListInteractorOutput()
        sut = UserListInteractor(listProcessor: listProcessor, socialService: socialService)
        sut.output = output
    }
    
    override func tearDown() {
        super.tearDown()
        listProcessor = nil
        socialService = nil
        sut = nil
        output = nil
    }
    
    func testThatItCorrectlyLoadsNextPage() {
        // given
        let users = [User(), User(), User()]
        listProcessor.getNextListPageCompletionReturnValue = .success(users)
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getNextListPage { receivedUsers in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(receivedUsers.value ?? [], users)
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertTrue(listProcessor.getNextListPageCompletionCalled)
    }
    
    func testThatItCorrectlyReloadsList() {
        // given
        let users = [User(), User(), User()]
        listProcessor.reloadListCompletionReturnValue = .success(users)
        
        // when
        let expectation = self.expectation(description: #function)
        sut.reloadList { receivedUsers in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(receivedUsers.value ?? [], users)
        }
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertTrue(listProcessor.reloadListCompletionCalled)
    }
    
    func testThatItDoesNotProcessRequestForUserWithoutFollowStatus() {
        // given
        let user = User(uid: UUID().uuidString)
        
        // when
        let expectation = self.expectation(description: #function)

        sut.processSocialRequest(to: user) { result in
            expectation.fulfill()
            XCTAssertTrue(result.isFailure)
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testThatItProcessesSocialRequest() {
        // given
        let user = User(uid: UUID().uuidString, visibility: ._public, followerStatus: .empty)
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.processSocialRequest(to: user) { result in
            expectation.fulfill()
            XCTAssertTrue(result.isSuccess)
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testThatItSetsAPI() {
        // given
        let api = MockUsersListAPI()
        
        // when
        sut.setAPI(api)
        
        // then
        XCTAssertTrue(listProcessor.setAPICalled)
        XCTAssertTrue((listProcessor.setAPIReceivedApi as? MockUsersListAPI) === api)
    }
    
    func testThatItCallsOutputWhenListLoadingStateIsUpdated() {
        sut.didUpdateListLoadingState(true)
        XCTAssertTrue(output.didUpdateListLoadingStateCalled)
        XCTAssertEqual(output.didUpdateListLoadingStateReceivedIsLoading, true)
        
        sut.didUpdateListLoadingState(false)
        XCTAssertTrue(output.didUpdateListLoadingStateCalled)
        XCTAssertEqual(output.didUpdateListLoadingStateReceivedIsLoading, false)
    }
}
