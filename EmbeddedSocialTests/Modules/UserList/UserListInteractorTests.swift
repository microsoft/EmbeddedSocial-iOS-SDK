//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserListInteractorTests: XCTestCase {
    var usersAPI: MockUsersListAPI!
    var socialService: MockSocialService!
    var sut: UserListInteractor!
    
    private let timeout: TimeInterval = 5.0
    
    override func setUp() {
        super.setUp()
        usersAPI = MockUsersListAPI()
        socialService = MockSocialService()
        sut = UserListInteractor(api: usersAPI, socialService: socialService)
    }
    
    override func tearDown() {
        super.tearDown()
        usersAPI = nil
        socialService = nil
        sut = nil
    }
    
    func testThatItGetsUsersList() {
        // given
        let users = [User(), User(), User()]
        let result: Result<UsersListResponse> = .success(UsersListResponse(users: users, cursor: nil))
        usersAPI.resultToReturn = result
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getNextListPage { receivedUsers in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(receivedUsers.value ?? [], users)
        }
        
        wait(for: [expectation], timeout: timeout)
    }
    
    func testThatItSetsCorrectLoadingState() {
        testThatItSetsCorrectLoadingState(cursor: nil, shouldHaveMoreItems: false)
        testThatItSetsCorrectLoadingState(cursor: UUID().uuidString, shouldHaveMoreItems: true)
    }
    
    func testThatItSetsCorrectLoadingState(cursor: String?, shouldHaveMoreItems: Bool) {
        // given
        usersAPI.resultToReturn = .success(UsersListResponse(users: [], cursor: cursor))
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getNextListPage { receivedUsers in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
        
        XCTAssertEqual(sut.isLoadingList, false)
        XCTAssertEqual(sut.listHasMoreItems, shouldHaveMoreItems)
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
        let user = User(uid: UUID().uuidString, followerStatus: .empty)
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.processSocialRequest(to: user) { result in
            expectation.fulfill()
            XCTAssertTrue(result.isSuccess)
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
