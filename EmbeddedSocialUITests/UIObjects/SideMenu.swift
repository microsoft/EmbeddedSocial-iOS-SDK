//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class SideMenu {
    var app: XCUIApplication
    var menuButton: XCUIElement
    var isOpened = false
    var userProfileOption: XCUIElement!
    
    init(_ app: XCUIApplication) {
        self.app = app
        self.menuButton = app.navigationBars.children(matching: .button).element(boundBy: 0)
        self.userProfileOption = app.children(matching: .window).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element(boundBy: 1).staticTexts[TestConfig.fullUserName]
    }
    
    func open() {
        if !isOpened {
            self.menuButton.tap()
            self.isOpened = true
        }
    }
    
    func close() {
        if isOpened {
            self.menuButton.tap()
            self.isOpened = false
        }
    }
    
    func navigateTo(_ menuItem: String) {
        self.open()
        self.app.tables.staticTexts[menuItem].tap()
        self.isOpened = false
        sleep(1) //Required for running without animations
    }
    
    func navigateToUserProfile() {
        self.open()
        self.userProfileOption.tap()
        self.isOpened = false
        sleep(1)
    }
}
