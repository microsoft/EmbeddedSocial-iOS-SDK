//
//  UserListInteractorTests.swift
//  EmbeddedSocial
//
//  Created by Vadim Bulavin on 8/3/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
        let result: Result<UsersListResponse> = .success(UsersListResponse(users: [], cursor: nil))
        usersAPI.resultToReturn = result
        
        // when
        let expectation = self.expectation(description: #function)
        
        sut.getUsersList(cursor: nil, limit: 1) { response in
            expectation.fulfill()
            
            // then
            XCTAssertEqual(response.value, result.value)
        }
        
        wait(for: [expectation], timeout: timeout)
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
