//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class UserProfile: UIObject, UIElementConvertible {
    
    var feed: Feed!
    
    var menu: XCUIElementQuery!

    var followersButton: XCUIElement!
    var followingButton: XCUIElement!
    var editProfileButton: XCUIElement!
    var followButton: XCUIElement!
    var recentPostsButton: XCUIElement!
    var popularPostsButton: XCUIElement!
    
    private var details: XCUIElement!
    private var menuButton: XCUIElement!
    
    override init(_ application: XCUIApplication) {
        menuButton = application.navigationBars.children(matching: .button).element(boundBy: 2)
        menu = application.sheets
        feed = Feed(application)
        
        details = application.collectionViews.children(matching: .other).element // application.collectionViews.element
        followersButton = details.buttons["Followers"].firstMatch
        followingButton = details.buttons["Following"].firstMatch
        editProfileButton = details.buttons["Edit"].firstMatch
        followButton = details.buttons["Follow"].firstMatch
        
        recentPostsButton = application.collectionViews.buttons["Recent posts"]
        popularPostsButton = application.collectionViews.buttons["Popular posts"]
        
        super.init(application)
    }
    
    func openMenu() {
        menuButton.tap()
    }
    
    func selectMenuOption(_ option: String) {
        menu.buttons[option].tap()
    }
    
    func textExists(_ text: String) -> Bool {
        return details.staticTexts[text].exists
    }
    
    func follow() {
        followButton.tap()
    }
    
    func back() {
        application.navigationBars.children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
    }
    
    func asUIElement() -> XCUIElement {
        return details
    }
    
}
