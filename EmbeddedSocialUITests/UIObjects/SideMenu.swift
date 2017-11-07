//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum SideMenuItem: String {
    case home         = "Home"
    case search       = "Search"
    case popular      = "Popular"
    case myPins       = "My pins"
    case activityFeed = "Activity Feed"
    case settings     = "Settings"
    case userProfile  = "Profile"
}

class SideMenu: UIObject {
    
    fileprivate var menuButton: XCUIElement
    fileprivate var userProfileOption: XCUIElement!
    
    override init(_ application: XCUIApplication) {
        menuButton = application.navigationBars.children(matching: .button).element(boundBy: 0)
        userProfileOption = application.children(matching: .window).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element(boundBy: 1).staticTexts[TestConfig.fullUserName]
        super.init(application)
    }
    
    func navigate(to menuItem: SideMenuItem) {
        if menuItem == .userProfile {
            navigateToUserProfile()
            return
        }
        navigateTo(menuItem.rawValue)
    }
    
}

extension SideMenu {
    
    fileprivate func navigateTo(_ menuItem: String) {
        open()
        application.tables.staticTexts[menuItem].tap()
        sleep(1) //Required for running without animations
    }
    
    fileprivate func navigateToUserProfile() {
        open()
        userProfileOption.tap()
        sleep(1)
    }
    
    private func open() {
        menuButton.tap()
    }
    
}
