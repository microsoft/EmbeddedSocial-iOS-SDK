//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class UserProfile {
    var app: XCUIApplication!
    var menuButton: XCUIElement!
    var menu: XCUIElementQuery!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.menuButton = app.navigationBars["EmbeddedSocial.NavigationStackContainer"].children(matching: .button).element(boundBy: 1)
        self.menu = app.sheets
    }
    
    func openMenu() {
        self.menuButton.tap()
    }
    
    func selectMenuOption(_ option: String) {
        self.menu.buttons[option].tap()
    }
    
    
}
