//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class Search {
    var app: XCUIApplication
    var topicsButton: XCUIElement
    var peopleButton: XCUIElement
    var topicsQuery: XCUIElement
    var peopleQuery: XCUIElement

    init(_ application: XCUIApplication) {
        self.app = application
        self.topicsButton = self.app.buttons["Topics"]
        self.peopleButton = self.app.buttons["People"]
        self.topicsQuery = self.app.searchFields["Search topics"]
        self.peopleQuery = self.app.searchFields["Search people"]
    }

}
