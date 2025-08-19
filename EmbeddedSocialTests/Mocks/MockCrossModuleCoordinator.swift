//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class CrossModuleCoordinatorProtocolMock: CrossModuleCoordinatorProtocol {
   
    var configuredHome: UIViewController = UIViewController()
    var configuredPopular: UIViewController = UIViewController()
    var configuredUserProfile: UIViewController = UIViewController()
    var configuredLogin: UIViewController = UIViewController()
    var configuredSearch: UIViewController = UIViewController()
    var configuredSettings: UIViewController = UIViewController()
    var configuredMyPins: UIViewController = UIViewController()
    var configuredActivity: UIViewController = UIViewController()
    
    //MARK: - closeMenu
    
    var closeMenuCalled = false
    
    func closeMenu() {
        closeMenuCalled = true
    }
    
    //MARK: - openHomeScreen
    
    var openHomeScreenCalled = false
    
    func openHomeScreen() {
        openHomeScreenCalled = true
    }
    
    //MARK: - openPopularScreen
    
    var openPopularScreenCalled = false
    
    func openPopularScreen() {
        openPopularScreenCalled = true
    }
    
    //MARK: - openMyProfile
    
    var openMyProfileCalled = false
    
    func openMyProfile() {
        openMyProfileCalled = true
    }
    
    //MARK: - openLoginScreen
    
    var openLoginScreenCalled = false
    
    func openLoginScreen() {
        openLoginScreenCalled = true
    }
    
    //MARK: - openSearchPeople
    
    var openSearchPeopleCalled = false
    
    func openSearchPeople() {
        openSearchPeopleCalled = true
    }
    
    //MARK: - logOut
    
    var logOutCalled = false
    
    func logOut() {
        logOutCalled = true
    }
    
    //MARK: - showError
    
    var showErrorCalled = false
    var showErrorReceivedError: Error?
    
    func showError(_ error: Error) {
        showErrorCalled = true
        showErrorReceivedError = error
    }
    
    //MARK: - isUserAuthenticated
    
    var isUserAuthenticatedCalled = false
    var isUserAuthenticatedReturnValue: Bool!
    
    func isUserAuthenticated() -> Bool {
        isUserAuthenticatedCalled = true
        return isUserAuthenticatedReturnValue
    }
    
}
