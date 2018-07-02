//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class CommentItem: UICellObject {
    
    var likeButton: XCUIElement
    var replyButton: XCUIElement
    var likesButton: XCUIElement
    var repliesButton: XCUIElement
    
    private var authorLabeL: XCUIElement
    private var titleLabel: XCUIElement
    
    private var menuButton: XCUIElement
    private var commentMenu: CommentMenu!
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        likeButton = cell.buttons["Like Comment"].firstMatch
        replyButton = cell.buttons["Reply Comment"].firstMatch
        likesButton = cell.buttons["Likes Comment"].firstMatch
        repliesButton = cell.buttons["Replies Comment"].firstMatch
        
        authorLabeL = cell.staticTexts.element(boundBy: 1)
        titleLabel = cell.staticTexts.element(boundBy: 0)
        menuButton = cell.buttons["Menu Comment"]
        
        super.init(application, cell: cell)
        
        commentMenu = CommentMenu(application, item: self)
    }
    
    func getAuthor() -> XCUIElement {
        return authorLabeL
    }
    
    func getTitle() -> XCUIElement {
        return titleLabel
    }
    
    func like() {
        scrollToElement(likeButton, application)
        likeButton.tap()
    }
    
    func reply() {
        scrollToElement(replyButton, application)
        replyButton.tap()
    }
    
    func openLikes() {
        scrollToElement(likesButton, application)
        likesButton.tap()
    }
    
    func openReplies() {
        scrollToElement(repliesButton, application)
        repliesButton.tap()
    }
    
    func menu() -> CommentMenu {
        if !commentMenu.isOpened {
            menuButton.tap()
            commentMenu.isOpened = true
        }
        return commentMenu
    }

}

class CommentsFeed: UIFeedObject <CommentItem> {
    
    var loadMoreButton: XCUIElement
    
    private var commentText: XCUIElement
    private var publishCommentButton: XCUIElement
    
    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element)
    }
    
    override init(_ application: XCUIApplication, feedContainer: XCUIElement) {
        loadMoreButton = application.buttons["Load more"].firstMatch
        commentText = application.textViews.firstMatch
        publishCommentButton = application.buttons["Post"].firstMatch
        
        super.init(application, feedContainer: feedContainer)
    }

    func postNewComment(with text: String) {
        commentText.tap()
        commentText.clearText()
        commentText.typeText(text)
        
        publishCommentButton.tap()
    }
    
}
