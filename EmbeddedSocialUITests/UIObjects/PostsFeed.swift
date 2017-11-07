//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class PostItem: UICellObject {
    
    var likeButton: XCUIElement
    var pinButton: XCUIElement
    var postImageButton: XCUIElement
    
    private var titleLabel: XCUIElement
    private var textLabeL: XCUIElement
    
    private var menuButton: XCUIElement
    private var postMenu: PostMenu!
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        likeButton = cell.buttons["Like Post"].firstMatch
        pinButton = cell.buttons["Pin Post"].firstMatch
        menuButton = cell.buttons["Menu Post"].firstMatch
        
        titleLabel = cell.staticTexts.element(boundBy: 2)
        textLabeL = cell.staticTexts.element(boundBy: 3)
        postImageButton = cell.buttons["Post Image"].firstMatch
        
        super.init(application, cell: cell)
        postMenu = PostMenu(application, item: self)
    }
    
    // Title value it's a "topicHandle" attribute
    func getTitle() -> XCUIElement {
        return titleLabel
    }
    
    func getText() -> XCUIElement {
        return textLabeL
    }
    
    func like() {
        scrollToElement(likeButton, application)
        likeButton.tap()
    }
    
    func pin() {
        scrollToElement(pinButton, application)
        pinButton.tap()
    }
    
    func menu() -> PostMenu {
        if !postMenu.isOpened {
            menuButton.tap()
            postMenu.isOpened = true
        }
        return postMenu
    }
    
}

class Feed: UIFeedObject <PostItem> {

    private var switchViewModeButton: XCUIElement
    
    init(_ application: XCUIApplication, switchViewModeButton: XCUIElement? = nil) {
        self.switchViewModeButton = switchViewModeButton ?? application.navigationBars.buttons.element(boundBy: 1)
        super.init(application, feedContainer: application.collectionViews.element)
    }
    
    func switchViewMode() {
        switchViewModeButton.tap()
    }
    
}
