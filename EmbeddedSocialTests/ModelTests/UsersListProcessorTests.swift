//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UsersListProcessorTests: XCTestCase {
    var usersAPI: MockUsersListAPI!
    var networkTracker: MockNetworkTracker!
    var sut: PaginatedListProcessor<User>!
    
    private let timeout: TimeInterval = 5.0
    private let pageSize = 10
    
    override func setUp() {
        super.setUp()
        usersAPI = MockUsersListAPI()
        networkTracker = MockNetworkTracker()
        sut = PaginatedListProcessor<User>(api: usersAPI, pageSize: pageSize, networkTracker: networkTracker)
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
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(items: users, cursor: nil, isFromCache: false))
        
        // when
        var result: Result<[User]>?
        sut.getNextListPage { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil())
        expect(result?.value?.count).toEventually(equal(users.count))
        expect(self.sut.isLoadingList).toEventually(beFalse())
    }
    
    func testThatItLoadsMultiplePages() {
        // given
        let page1 = [User(), User(), User()]
        let response1 = UsersListResponse(items: page1, cursor: UUID().uuidString, isFromCache: false)
        
        let page2 = [User(), User(), User()]
        let response2 = UsersListResponse(items: page2, cursor: nil, isFromCache: false)
        
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
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(items: [], cursor: cursor, isFromCache: false))
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getNextListPage { receivedUsers in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertEqual(sut.isLoadingList, false)
        XCTAssertEqual(sut.listHasMoreItems, shouldHaveMoreItems)
    }
    
    func testThatItSkipsCacheWhenReloadsListWithAvailableNetwork() {
        // given
        let shortTimeout: TimeInterval = 0.1
        let users = [User(), User(), User()]
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(items: users, cursor: nil, isFromCache: true))
        networkTracker.isReachable = true
        
        // when
        var result: Result<[User]>?
        sut.reloadList { result = $0 }
        
        // then
        expect(result).toEventually(beNil(), timeout: shortTimeout)
    }
    
    func testThatItReloadsList() {
        // given
        let users = [User(), User(), User()]
        usersAPI.getUsersListReturnValue = .success(UsersListResponse(items: users, cursor: nil, isFromCache: false))
        
        // when
        var result: Result<[User]>?
        sut.reloadList { result = $0 }
        
        // then
        expect(result?.value).toEventually(equal(users))
    }
}
