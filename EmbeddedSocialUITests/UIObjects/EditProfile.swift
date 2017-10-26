//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class EditProfile {
    
    private var app: XCUIApplication!
    private var editContainer: XCUIElementQuery!
    private var firstNameInput: XCUIElement!
    private var lastNameInput: XCUIElement
    private var bioInput: XCUIElement!
    private var saveButton: XCUIElement!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.editContainer = self.app.tables
        self.firstNameInput = self.editContainer.cells["First Name"].children(matching: .textField).element
        self.lastNameInput = self.editContainer.cells["Last Name"].children(matching: .textField).element
        self.bioInput = self.editContainer.cells["Bio"].children(matching: .textView).element
        self.saveButton = self.app.navigationBars.buttons["Save"]
    }
    
    func updateProfileWith(firstName: String, lastName: String, bio: String) {
        firstNameInput.clearText()
        firstNameInput.typeText(firstName)
        lastNameInput.clearText()
        lastNameInput.typeText(lastName)
        bioInput.clearText()
        bioInput.typeText(bio)
        
        saveButton.tap()
    }
    
}
