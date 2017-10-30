//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SettingsInteractorTests: XCTestCase {
    
    var logoutController: MockLogoutController!
    var usersService: MockUserService!
    var sut: SettingsInteractor!
    
    override func setUp() {
        super.setUp()
        logoutController = MockLogoutController()
        usersService = MockUserService()
        sut = SettingsInteractor(userService: usersService, logoutController: logoutController)
    }
    
    override func tearDown() {
        super.tearDown()
        logoutController = nil
        usersService = nil
        sut = nil
    }
    
    func testSignOut() {
        sut.signOut()
        expect(self.logoutController.logOutCount).to(equal(1))
    }
    
    func testSwitchVisibility() {
        usersService.updateVisibilityReturnValue = .success()
        
        var result: Result<Visibility>?
        
        sut.switchVisibility(._public) { result = $0 }
        expect(result?.value).toEventually(equal(._private))
        expect(self.usersService.updateVisibilityCount).to(equal(1))
        
        sut.switchVisibility(._private) { result = $0 }
        expect(result?.value).toEventually(equal(._public))
        expect(self.usersService.updateVisibilityCount).to(equal(2))
    }
    
    func testDeleteAccount() {
        usersService.deleteAccountResult = .success()
        sut.deleteAccount { _ in () }
        expect(self.usersService.deleteAccountCalled).toEventually(beTrue())
        expect(self.logoutController.logOutCount).toEventually(equal(1))
    }
    
    func testDeleteAccountError() {
        var result: Result<Void>?
        usersService.deleteAccountResult = .failure(APIError.unknown)
        sut.deleteAccount { result = $0 }
        expect(result?.error).toEventually(matchError(APIError.unknown))
        expect(self.usersService.deleteAccountCalled).toEventually(beTrue())
        expect(self.logoutController.logOutCount).to(equal(0))
    }
}
