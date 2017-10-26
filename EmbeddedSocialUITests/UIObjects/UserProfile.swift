//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class UserProfile {
    
    var feed: Feed!
    
    var menu: XCUIElementQuery!

    var followersButton: XCUIElement!
    var followingButton: XCUIElement!
    var editProfileButton: XCUIElement!
    var followButton: XCUIElement!
    var recentPostsButton: XCUIElement!
    var popularPostsButton: XCUIElement!
    
    private var app: XCUIApplication!
    private var details: XCUIElement!
    private var menuButton: XCUIElement!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.menuButton = app.navigationBars.children(matching: .button).element(boundBy: 2)
        self.menu = app.sheets
        self.feed = Feed(app)
        
        self.details = app.collectionViews.children(matching: .other).element // app.collectionViews.element
        self.followersButton = details.buttons["Followers"].firstMatch
        self.followingButton = details.buttons["Following"].firstMatch
        self.editProfileButton = details.buttons["Edit"].firstMatch
        self.followButton = details.buttons["Follow"].firstMatch
        
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
    
    func asUIElement() -> XCUIElement {
        return details
    }
    
}
