//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class LinkedAccountsInteractorTests: XCTestCase {
    var sut: LinkedAccountsInteractor!
    var usersService: MockUserService!
    var authService: MockAuthService!
    var sessionToken: String!
    
    let timeout: TimeInterval = 1.0
    
    override func setUp() {
        super.setUp()
        usersService = MockUserService()
        authService = MockAuthService()
        sessionToken = UUID().uuidString
        sut = LinkedAccountsInteractor(usersService: usersService, authService: authService, sessionToken: sessionToken)
    }
    
    override func tearDown() {
        super.tearDown()
        usersService = nil
        authService = nil
        sessionToken = nil
        sut = nil
    }
    
    func testThatItGetsLinkedAccounts() {
        // given
        usersService.getLinkedAccountsReturnValue = .success([])
        var result: Result<[LinkedAccountView]>?

        // when
        sut.getLinkedAccounts { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil(), timeout: timeout)
        expect(self.usersService.getLinkedAccountsCalled).toEventually(beTrue(), timeout: timeout)
    }
    
    func testThatItPropagatesGetLinkedAccountError() {
        // given
        usersService.getLinkedAccountsReturnValue = .failure(APIError.unknown)
        var result: Result<[LinkedAccountView]>?
        
        // when
        sut.getLinkedAccounts { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil(), timeout: timeout)
        expect(result?.error).toEventually(matchError(APIError.unknown), timeout: timeout)
        expect(self.usersService.getLinkedAccountsCalled).toEventually(beTrue(), timeout: timeout)
    }
    
    func testThatItLogsIn() {
        // given
        let creds = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = SocialUser(credentials: creds, firstName: UUID().uuidString,
                              lastName: UUID().uuidString, email: UUID().uuidString, photo: Photo())
        authService.loginReturnValue = .success(user)
        
        var result: Result<Authorization>?
        
        // when
        sut.login(with: .facebook, from: UIViewController()) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil(), timeout: timeout)
        expect(result?.value).toEventually(equal(creds.authorization), timeout: timeout)
        expect(self.authService.loginCalled).toEventually(beTrue())
    }
    
    func testThatItReturnsLoginError() {
        // given
        authService.loginReturnValue = .failure(APIError.unknown)
        var result: Result<Authorization>?
        
        // when
        sut.login(with: .facebook, from: UIViewController()) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil(), timeout: timeout)
        expect(result?.error).toEventually(matchError(APIError.unknown), timeout: timeout)
        expect(self.authService.loginCalled).toEventually(beTrue())
    }
    
    func testThatItLinksAccount() {
        // given
        usersService.linkAccountReturnValue = .success()
        let authorization: Authorization = UUID().uuidString
        var result: Result<Void>?
        
        // when
        sut.linkAccount(provider: .facebook, authorization: authorization) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil(), timeout: timeout)
        expect(self.usersService.linkAccountCalled).toEventually(beTrue(), timeout: timeout)
        expect(self.usersService.linkAccountInputValues?.sessionToken).toEventually(equal(self.sessionToken), timeout: timeout)
        expect(self.usersService.linkAccountInputValues?.authorization).toEventually(equal(authorization), timeout: timeout)
    }
    
    func testThatItReturnsLinkAccountErrorResult() {
        // given
        usersService.linkAccountReturnValue = .failure(APIError.unknown)
        let authorization: Authorization = UUID().uuidString
        var result: Result<Void>?
        
        // when
        sut.linkAccount(provider: .facebook, authorization: authorization) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil(), timeout: timeout)
        expect(result?.error).toEventually(matchError(APIError.unknown), timeout: timeout)
        expect(self.usersService.linkAccountCalled).toEventually(beTrue(), timeout: timeout)
        expect(self.usersService.linkAccountInputValues?.sessionToken).toEventually(equal(self.sessionToken), timeout: timeout)
        expect(self.usersService.linkAccountInputValues?.authorization).toEventually(equal(authorization), timeout: timeout)
    }
    
    func testThatItDeletesLinkedAccount() {
        let acc1 = LinkedAccountView()
        acc1.identityProvider = .facebook
        
        let acc2 = LinkedAccountView()
        acc2.identityProvider = .twitter
        
        usersService.getLinkedAccountsReturnValue = .success([acc1, acc2])
        sut.getLinkedAccounts { _ in () }
        expect(self.usersService.getLinkedAccountsCalled).toEventually(beTrue())
        
        // 1st deleted
        var result: Result<Void>?
        usersService.deleteLinkedAccountReturnValue = .success()
        sut.deleteLinkedAccount(provider: .facebook) { result = $0 }
        
        expect(self.usersService.deleteLinkedAccountCalled).toEventually(beTrue())
        expect(self.usersService.deleteLinkedAccountInputProvider).to(equal(.facebook))
        expect(result?.isSuccess).to(beTrue())
        
        // 2nd deleted
        result = nil
        usersService.deleteLinkedAccountCalled = false
        sut.deleteLinkedAccount(provider: .twitter) { result = $0 }
        expect(result?.isFailure).toEventually(beTrue(), timeout: timeout)
        expect(result?.error).to(matchError(APIError.lastLinkedAccount))
        expect(self.usersService.deleteLinkedAccountCalled).to(beFalse())
    }
    
    func testDeleteAccountWhenNoAccountsLoaded() {
        var result: Result<Void>?
        sut.deleteLinkedAccount(provider: .facebook) { result = $0 }
        
        expect(result?.isFailure).toEventually(beTrue(), timeout: timeout)
        expect(result?.error).to(matchError(APIError.lastLinkedAccount))
        expect(self.usersService.deleteLinkedAccountCalled).to(beFalse())
    }
}
