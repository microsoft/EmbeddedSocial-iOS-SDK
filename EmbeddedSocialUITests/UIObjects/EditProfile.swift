//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class EditProfile: UIObject {
    
    private var editContainer: XCUIElementQuery!
    private var firstNameInput: XCUIElement!
    private var lastNameInput: XCUIElement
    private var bioInput: XCUIElement!
    private var saveButton: XCUIElement!
    
    override init(_ application: XCUIApplication) {
        editContainer = application.tables
        firstNameInput = editContainer.cells["First Name"].children(matching: .textField).element
        lastNameInput = editContainer.cells["Last Name"].children(matching: .textField).element
        bioInput = editContainer.cells["Bio"].children(matching: .textView).element
        saveButton = application.navigationBars.buttons["Save"]
        super.init(application)
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
