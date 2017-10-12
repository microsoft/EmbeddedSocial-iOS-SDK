//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class Post {
    
    var app: XCUIApplication
    var cell: XCUIElement
    var teaser: XCUIElement
    var likeButton: XCUIElement
    var pinButton: XCUIElement
    
    var postImageButton: XCUIElement
    
    private var titleLabel: XCUIElement
    
    private var menuButton: XCUIElement
    private var postMenu: PostMenu!
    
    init(_ cell: XCUIElement, _ application: XCUIApplication) {
        self.app = application
        self.cell = cell
        self.teaser = self.cell.textViews["Teaser"]
        self.likeButton = self.cell.buttons["Like"]
        self.pinButton = self.cell.buttons["Pin"]
        self.menuButton = self.cell.buttons["Post Menu"]
        
        titleLabel = self.cell.staticTexts.element(boundBy: 2)
        postImageButton = self.cell.buttons["Post Image"]
        
        postMenu = PostMenu(app, self)
    }
    
    //UILabel values cannot be read when element has an accessibility identifier
    //and should be verified by searching of static texts inside cells
    //https://forums.developer.apple.com/thread/10428
    func textExists(_ text: String) -> Bool {
        return self.cell.staticTexts[text].exists
    }
    
    func getLabelByText(_ text: String) -> XCUIElement {
        return self.cell.staticTexts[text]
    }
    
    // Title value it's a "topicHandle" attribute
    func getTitle() -> String {
        return titleLabel.label
    }
    
    func like() {
        scrollToElement(self.likeButton, self.app)
        self.likeButton.tap()
//        sleep(1)
    }
    
    func pin() {
        scrollToElement(self.pinButton, self.app)
        self.pinButton.tap()
//        sleep(1)
    }
    
    func menu() -> PostMenu {
        if !postMenu.isOpened {
            menuButton.tap()
            postMenu.isOpened = true
        }
        return postMenu
    }
    
}

class Feed {
    var app: XCUIApplication
    var feedContainer: XCUIElementQuery
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.feedContainer = self.app.collectionViews
    }
    
    func switchViewMode() {
        var viewModeButton: XCUIElement
        if app.navigationBars.children(matching: .button).element(boundBy: 1).exists {
            viewModeButton = app.navigationBars.children(matching: .button).element(boundBy: 1)
        } else {
            viewModeButton = app.navigationBars.children(matching: .button).element(boundBy: 2)
        }
        viewModeButton.tap()
    }
    
    func getPostsCount() -> UInt {
        return UInt(self.feedContainer.cells.count)
    }
    
    func getPost(_ index: UInt) -> Post {
        return Post(self.feedContainer.children(matching: .cell).element(boundBy: index), self.app)
    }
    
    func getRandomPost() -> (UInt, Post) {
        let index = Random.randomUInt(self.getPostsCount())
        return (index, self.getPost(index))
    }
}
