//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class UserProfile {
    var app: XCUIApplication!
    var feed: Feed!
    var details: XCUIElement!
    var followersButton: XCUIElement!
    var followingButton: XCUIElement!
    var editProfileButton: XCUIElement!
    var followButton: XCUIElement!
    var recentPostsButton: XCUIElement!
    var popularPostsButton: XCUIElement!
    var menuButton: XCUIElement!
    var menu: XCUIElementQuery!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.menuButton = app.navigationBars.children(matching: .button).element(boundBy: 2)
        self.menu = app.sheets
        self.feed = Feed(app)
        self.details = app.collectionViews.children(matching: .other).element // app.collectionViews.element
        self.followersButton = details.buttons.element(boundBy: 0)
        self.followingButton = details.buttons.element(boundBy: 1)
        self.editProfileButton = details.buttons.element(boundBy: 2)
        // Edit profile in My Profile and Follow in other user profiles
        self.followButton = details.buttons.element(boundBy: 3)
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
    
    func follow() {
        self.followButton.tap()
    }
    
    func back() {
        app.navigationBars.children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
    }
}
