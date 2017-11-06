//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class EditPost: UIObject {
    
    private var postTitle: XCUIElement
    private var postText: XCUIElement
    private var saveButton: XCUIElement
    
    override init(_ application: XCUIApplication) {
        postTitle = application.scrollViews.textFields["Post Title"]
        postText = application.scrollViews.textViews["Post Text"]
        saveButton = application.navigationBars.element.buttons.element(boundBy: 1)
        super.init(application)
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
