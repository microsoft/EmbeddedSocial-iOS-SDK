//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UsersListProcessorTests: XCTestCase {
    var usersAPI: MockUsersListAPI!
    var networkTracker: MockNetworkTracker!
    var sut: UsersListProcessor!
    
    private let timeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        usersAPI = MockUsersListAPI()
        networkTracker = MockNetworkTracker()
        sut = UsersListProcessor(api: usersAPI, networkTracker: networkTracker)
    }
    
    override func tearDown() {
        super.tearDown()
        usersAPI = nil
        networkTracker = nil
        sut = nil
    }
    
    func testThatItGetsUsersList() {
        // given
        let users = [User(), User(), User()]
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(users: users, cursor: nil, isFromCache: false))
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getNextListPage { receivedUsers in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(receivedUsers.value ?? [], users)
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertFalse(sut.isLoadingList)
    }
    
    func testThatItLoadsMultiplePages() {
        // given
        let page1 = [User(), User(), User()]
        let response1 = UsersListResponse(users: page1, cursor: UUID().uuidString, isFromCache: false)
        
        let page2 = [User(), User(), User()]
        let response2 = UsersListResponse(users: page2, cursor: nil, isFromCache: false)
        
        // when
        // page 1 is loaded
        usersAPI.getUsersListReturnValue = .success(response1)
        sut.getNextListPage { result in
            XCTAssertEqual(result.value ?? [], page1)
        }
        
        // then
        XCTAssertTrue(sut.listHasMoreItems)
        XCTAssertFalse(sut.isLoadingList)
        
        // when
        // page 2 is loaded
        usersAPI.getUsersListReturnValue = .success(response2)
        sut.getNextListPage { result in
            XCTAssertEqual(result.value ?? [], page1 + page2)
        }
        
        // then
        XCTAssertFalse(sut.listHasMoreItems)
        XCTAssertFalse(sut.isLoadingList)
    }
    
    func testThatItSetsCorrectLoadingState() {
        testThatItSetsCorrectLoadingState(cursor: nil, shouldHaveMoreItems: false)
        testThatItSetsCorrectLoadingState(cursor: UUID().uuidString, shouldHaveMoreItems: true)
    }
    
    func testThatItSetsCorrectLoadingState(cursor: String?, shouldHaveMoreItems: Bool) {
        // given
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(users: [], cursor: cursor, isFromCache: false))
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getNextListPage { receivedUsers in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertEqual(sut.isLoadingList, false)
        XCTAssertEqual(sut.listHasMoreItems, shouldHaveMoreItems)
    }
    
    func testThatItSkipsCacheWhenReloadsList() {
        // given
        let shortTimeout: TimeInterval = 0.1
        let users = [User(), User(), User()]
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(users: users, cursor: nil, isFromCache: true))
        
        // when
        let expectation = self.expectation(description: #function)
        expectation.isInverted = true
        sut.reloadList { receivedUsers in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(receivedUsers.value ?? [], users)
        }
        wait(for: [expectation], timeout: shortTimeout)
    }
    
    func testThatItReloadsList() {
        // given
        let users = [User(), User(), User()]
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(users: users, cursor: nil, isFromCache: false))
        
        // when
        let expectation = self.expectation(description: #function)
        sut.reloadList { receivedUsers in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(receivedUsers.value ?? [], users)
        }
        wait(for: [expectation], timeout: timeout)
    }
}
