//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CrossModuleCoordinatorMock: CrossModuleCoordinatorProtocol {
    
    var authenticated: Bool!
    
    func isUserAuthenticated() -> Bool { return authenticated }
    
    func closeMenu() {}
    func openHomeScreen() {}
    func openMyProfile() {}
    func openLoginScreen() {}
    func logOut() {}
    func showError(_ error: Error) {}
    var configuredHome: UIViewController { return UIViewController() }
    var configuredPopular: UIViewController { return UIViewController() }
    var configuredDebug: UIViewController { return UIViewController() }
    
}
class SocialMenuItemsProviderTests: XCTestCase {

    var coordinator: CrossModuleCoordinatorMock!
    
    override func setUp() {
        super.setUp()
        
        coordinator = CrossModuleCoordinatorMock()
    }
    
    func testThatItemsAccessedBySocialKeysAreValidWhenNotAuthenticated() {
        
        // given 
        
        coordinator.authenticated = false
        let sut = SocialMenuItemsProvider(coordinator: coordinator)
        
        // when
        let homeIndex = sut.getMenuItemIndex(for: SocialMenuItemsProvider.SocialItem.home)
        let popularIndex = sut.getMenuItemIndex(for: SocialMenuItemsProvider.SocialItem.popular)
        
        // then
        XCTAssertTrue(sut.state == .unauthenticated)
        XCTAssertTrue(homeIndex == nil)
        XCTAssertTrue(popularIndex != nil)
        XCTAssertTrue(sut.title(forItem: popularIndex!) == L10n.Popular.screenTitle)
    }
    
    func testThatItemsAccessedBySocialKeysAreValidWhenAuthenticated() {
        
        // given
        
        coordinator.authenticated = true
        let sut = SocialMenuItemsProvider(coordinator: coordinator)
        
        
        
        // when
        let homeIndex = sut.getMenuItemIndex(for: SocialMenuItemsProvider.SocialItem.home)
        let popularIndex = sut.getMenuItemIndex(for: SocialMenuItemsProvider.SocialItem.popular)

        
        // then
        XCTAssertTrue(sut.state == .authenticated)
        XCTAssertTrue(homeIndex != nil)
        XCTAssertTrue(popularIndex != nil)
        XCTAssertTrue(sut.title(forItem: homeIndex!) == L10n.Home.screenTitle)
        XCTAssertTrue(sut.title(forItem: popularIndex!) == L10n.Popular.screenTitle)
        
    }
    
}
