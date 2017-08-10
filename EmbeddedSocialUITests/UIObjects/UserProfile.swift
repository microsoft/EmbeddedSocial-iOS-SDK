//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class UserProfile {
    var app: XCUIApplication!
    var feed: PostsFeed!
    var details: XCUIElement!
    var followersButton: XCUIElement!
    var followingButton: XCUIElement!
    var editProfileButton: XCUIElement!
    var recentPostsButton: XCUIElement!
    var popularPostsButton: XCUIElement!
    var menuButton: XCUIElement!
    var menu: XCUIElementQuery!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.menuButton = app.navigationBars["EmbeddedSocial.NavigationStackContainer"].children(matching: .button).element(boundBy: 1)
        self.menu = app.sheets
        self.feed = PostsFeed(app)
        self.details = app.collectionViews.children(matching: .other).element
        self.followersButton = details.buttons.element(boundBy: 0)
        self.followingButton = details.buttons.element(boundBy: 1)
        self.editProfileButton = details.buttons.element(boundBy: 2)
        self.recentPostsButton = app.collectionViews.buttons["Recent posts"]
        self.popularPostsButton = app.collectionViews.buttons["Popular posts"]
    }
    
    func openMenu() {
        self.menuButton.tap()
    }
    
    func selectMenuOption(_ option: String) {
        self.menu.buttons[option].tap()
    }
    
    func textExists(_ text: String) -> Bool {
        return self.details.staticTexts[text].exists
    }
}
