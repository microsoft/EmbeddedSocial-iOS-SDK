//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest


class PopularTopics {
    var app: XCUIApplication!
    var todayButton: XCUIElement!
    var thisWeekButton: XCUIElement!
    var allTimeButton: XCUIElement!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.todayButton = self.app.buttons["Today"]
        self.thisWeekButton = self.app.buttons["This week"]
        self.allTimeButton = self.app.buttons["All time"]
    }
}
