//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class EditProfile {
    var app: XCUIApplication!
    var editContainer: XCUIElementQuery!
    var firstNameInput: XCUIElement!
    var lastNameInput: XCUIElement
    var bioInput: XCUIElement!
    var saveButton: XCUIElement!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.editContainer = self.app.tables
        self.firstNameInput = self.editContainer.cells["First Name"].children(matching: .textField).element
        self.lastNameInput = self.editContainer.cells["Last Name"].children(matching: .textField).element
        self.bioInput = self.editContainer.cells["Bio"].children(matching: .textView).element
        self.saveButton = self.app.navigationBars.buttons["Save"]
    }
}
