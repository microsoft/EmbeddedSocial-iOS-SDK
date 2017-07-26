//
//  CreateAccountInteractorTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class CreateAccountInteractorTests: XCTestCase {
    var userService: MockUserService!
    var sut: CreateAccountInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        sut = CreateAccountInteractor(userService: userService)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        sut = nil
    }
    
    func testThatAccountIsCreated() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
            
        // when
        sut.createAccount(for: user) { _ in () }
        
        // then
        XCTAssertEqual(userService.createAccountCount, 1)
    }
}
