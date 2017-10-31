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
    var storage: SearchHistoryStorage!
    
    override func setUp() {
        super.setUp()
        logoutController = MockLogoutController()
        usersService = MockUserService()
        storage = SearchHistoryStorage(storage: UserDefaults.standard, userID: "123")
        sut = SettingsInteractor(userService: usersService, logoutController: logoutController, searchHistoryStorage: storage)
    }
    
    override func tearDown() {
        super.tearDown()
        logoutController = nil
        usersService = nil
        sut = nil
        storage = nil
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
    
    func testDeleteSearchHistory() {
        storage.save("1")
        storage.save("2")
        storage.save("3")
        expect(self.storage.searchRequests().count).to(equal(3))
        
        sut.deleteSearchHistory()
        expect(self.storage.searchRequests().count).to(equal(0))
    }
}
