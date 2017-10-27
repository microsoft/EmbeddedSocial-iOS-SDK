//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class Post {
    
    var likeButton: XCUIElement
    var pinButton: XCUIElement
    var postImageButton: XCUIElement

    private var app: XCUIApplication
    private var cell: XCUIElement
    
    private var titleLabel: XCUIElement
    private var textLabeL: XCUIElement
    
    private var menuButton: XCUIElement
    private var postMenu: PostMenu!
    
    init(_ cell: XCUIElement, _ application: XCUIApplication) {
        self.app = application
        self.cell = cell
        self.likeButton = self.cell.buttons["Like Post"].firstMatch
        self.pinButton = self.cell.buttons["Pin Post"].firstMatch
        self.menuButton = self.cell.buttons["Menu Post"].firstMatch
        
        titleLabel = self.cell.staticTexts.element(boundBy: 2)
        textLabeL = self.cell.staticTexts.element(boundBy: 3)
        
        postImageButton = self.cell.buttons["Post Image"].firstMatch
        
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
    func getTitle() -> XCUIElement {
        return titleLabel
    }
    
    func getText() -> XCUIElement {
        return textLabeL
    }
    
    func like() {
        scrollToElement(likeButton, app)
        self.likeButton.tap()
    }
    
    func pin() {
        scrollToElement(pinButton, app)
        pinButton.tap()
    }
    
    func menu() -> PostMenu {
        if !postMenu.isOpened {
            menuButton.tap()
            postMenu.isOpened = true
        }
        return postMenu
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}

class Feed {
    var app: XCUIApplication
    var feedContainer: XCUIElementQuery
    
    private var switchViewModeButton: XCUIElement
    
    init(_ application: XCUIApplication, switchViewModeButton: XCUIElement? = nil) {
        self.app = application
        self.feedContainer = self.app.collectionViews
        
        self.switchViewModeButton = switchViewModeButton ?? application.navigationBars.buttons.element(boundBy: 1)
    }
    
    func switchViewMode() {
        switchViewModeButton.tap()
    }
    
    func getPostsCount() -> UInt {
        return UInt(feedContainer.cells.count)
    }
    
    func getPost(_ index: UInt) -> Post {
        return Post(feedContainer.children(matching: .cell).element(boundBy: index), app)
    }
    
    func getRandomPost() -> (UInt, Post) {
        let index = Random.randomUInt(getPostsCount())
        return (index, getPost(index))
    }
}
