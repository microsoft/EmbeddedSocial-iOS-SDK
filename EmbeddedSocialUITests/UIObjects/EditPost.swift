//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class EditPost {
    
    private var application: XCUIApplication
    private var postTitle: XCUIElement
    private var postText: XCUIElement
    private var saveButton: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.application = application
        postTitle = self.application.scrollViews.textFields["Post Title"]
        postText = self.application.scrollViews.textViews["Post Text"]
        saveButton = self.application.navigationBars.element.buttons.element(boundBy: 1)
    }
    
    func updatePostWith(title: String, text: String) {
        postTitle.clearText()
        postTitle.typeText(title)

        application.keyboards.buttons["Next:"].tap()
        
        postText.clearText()
        postText.typeText(text)
    }
    
    func save() {
        saveButton.tap()
    }
    
}
