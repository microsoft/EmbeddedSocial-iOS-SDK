//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class CreatePost: UIObject {

    private var postTitle: XCUIElement
    private var postText: XCUIElement
    private var publishButton: XCUIElement
    
    override init(_ application: XCUIApplication) {
        postTitle = application.textFields["Post Title"]
        postText = application.textViews["Post Text"]
        publishButton = application.navigationBars["Add new post"].buttons["Post"]
        super.init(application)
    }
    
    func publishWith(title: String, text: String) {
        postTitle.tap()
        postTitle.typeText(title)
        postText.tap()
        postText.typeText(text)
        
        publishButton.tap()
    }

}
