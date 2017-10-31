//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class Follower {
    var cell: XCUIElement!
    var followButton: XCUIElement!
    
    init(_ cell: XCUIElement) {
        self.cell = cell
        self.followButton = self.cell.buttons.element(boundBy: 0)
    }
    
    func textExists(_ text: String) -> Bool {
        return self.cell.staticTexts[text].exists
    }
    
    func follow() {
        self.followButton.tap()
    }
    
}

class FollowersFeed {
    var app: XCUIApplication!
    var feedContainer: XCUIElement!
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.feedContainer = app.tables["UserList"]
    }
    
    func getFollowersCount() -> UInt {
        return UInt(self.feedContainer.cells.count)
    }
    
    func getFollower(_ index: UInt) -> Follower {
        scrollToElement(self.feedContainer.cells.element(boundBy: index), self.app)
        return Follower(self.feedContainer.cells.element(boundBy: index))
    }
    
    func getRandomFollower() -> (UInt, Follower) {
        let index = Random.randomUInt(self.getFollowersCount())
        return (index, self.getFollower(index))
    }
    
    func back() {
        app.navigationBars.children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
    }
    
    func asUIElement() -> XCUIElement {
        return feedContainer
    }
    
}
