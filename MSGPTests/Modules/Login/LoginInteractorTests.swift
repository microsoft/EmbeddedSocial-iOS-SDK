//
//  LoginInteractorTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class LoginInteractorTests: XCTestCase {
    var authService: MockAuthService!
    var userService: MockUserService!
    var sessionService: MockSessionService!
    var sut: LoginInteractor!
    
    override func setUp() {
        super.setUp()
        authService = MockAuthService()
        userService = MockUserService()
        sessionService = MockSessionService()
        sut = LoginInteractor(authService: authService, userService: userService, sessionService: sessionService)
    }
    
    override func tearDown() {
        super.tearDown()
        authService = nil
        userService = nil
        sessionService = nil
        sut = nil
    }
    
    func testThatLoginSucceeds() {
        // given

        // when
        sut.login(provider: .facebook, from: nil) { _ in () }
        
        // then
        XCTAssertEqual(authService.loginCount, 1)
    }
    
    func testThatGetMyProfileSucceeds() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
        
        // when
        sut.getMyProfile(socialUser: user) { _ in () }
        
        // then
        XCTAssertEqual(userService.getMyProfileCount, 1)
    }
}
