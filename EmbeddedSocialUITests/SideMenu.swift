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
    
    init(_ app: XCUIApplication) {
        self.app = app
        self.menuButton = app.navigationBars["EmbeddedSocial.NavigationStackContainer"].children(matching: .button).element
        
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
    }
}
