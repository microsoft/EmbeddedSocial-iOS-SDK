//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class CreatePost {

    var app: XCUIApplication
    var postTitle: XCUIElement
    var postText: XCUIElement
    var publishButton: XCUIElement
    
    init(application: XCUIApplication) {
        app = application
        postTitle = app.textFields["Post Title"]
        postText = app.textViews["Post Text"]
        publishButton = app.navigationBars["Add new post"].buttons["Post"]
    }
    
    func publish() {
        publishButton.tap()
    }

}
