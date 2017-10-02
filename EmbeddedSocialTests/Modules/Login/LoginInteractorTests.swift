//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

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
        let creds = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = SocialUser(credentials: creds, firstName: nil, lastName: nil, email: nil, photo: nil)
        authService.loginReturnValue = .success(user)
        
        var result: Result<SocialUser>?

        // when
        sut.login(provider: .facebook, from: nil) { result = $0 }
        
        // then
        expect(self.authService.loginCalled).toEventually(beTrue())
        expect(result).toEventuallyNot(beNil())
    }
    
    func testThatGetMyProfileSucceeds() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
        let vc = UIViewController()
        
        // when
        sut.getMyProfile(socialUser: user, from: vc) { _ in () }
        
        // then
        XCTAssertEqual(userService.getMyProfileCount, 1)
    }
}
