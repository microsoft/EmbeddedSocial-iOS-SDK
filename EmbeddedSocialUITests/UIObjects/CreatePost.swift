//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class CreatePost {

    private var app: XCUIApplication
    private var postTitle: XCUIElement
    private var postText: XCUIElement
    private var publishButton: XCUIElement
    
    init(_ application: XCUIApplication) {
        app = application
        
        postTitle = app.textFields["Post Title"]
        postText = app.textViews["Post Text"]
        publishButton = app.navigationBars["Add new post"].buttons["Post"]
    }
    
    func publishWith(title: String, text: String) {
        postTitle.tap()
        postTitle.typeText(title)
        postText.tap()
        postText.typeText(text)
        
        publishButton.tap()
    }

}
