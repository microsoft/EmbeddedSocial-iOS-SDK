//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class Comment {
    
    var likeButton: XCUIElement
    var replyButton: XCUIElement
    var likesButton: XCUIElement
    var repliesButton: XCUIElement
    
    private var app: XCUIApplication
    private var cell: XCUIElement
    
    private var authorLabeL: XCUIElement
    private var titleLabel: XCUIElement
    
    private var menuButton: XCUIElement
    private var commentMenu: CommentMenu!
    
    init(_ cell: XCUIElement, _ application: XCUIApplication) {
        self.app = application
        self.cell = cell
        
        self.likeButton = self.cell.buttons["Like Comment"].firstMatch
        self.replyButton = self.cell.buttons["Reply Comment"].firstMatch
        self.likesButton = self.cell.buttons["Likes Comment"].firstMatch
        self.repliesButton = self.cell.buttons["Replies Comment"].firstMatch
        
        self.authorLabeL = self.cell.staticTexts.firstMatch
        self.titleLabel = self.cell.staticTexts.element(boundBy: 1)
        
        menuButton = self.cell.buttons["Menu Comment"]
        commentMenu = CommentMenu(app, self)
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
    
    func getAuthor() -> XCUIElement {
        return authorLabeL
    }
    
    func getTitle() -> XCUIElement {
        return titleLabel
    }
    
    func like() {
        scrollToElement(likeButton, app)
        likeButton.tap()
    }
    
    func reply() {
        scrollToElement(replyButton, app)
        replyButton.tap()
    }
    
    func openLikes() {
        scrollToElement(likesButton, app)
        likesButton.tap()
    }
    
    func openReplies() {
        scrollToElement(repliesButton, app)
        repliesButton.tap()
    }
    
    func menu() -> CommentMenu {
        if !commentMenu.isOpened {
            menuButton.tap()
            commentMenu.isOpened = true
        }
        return commentMenu
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }

}

class CommentsFeed {
    
    var loadMoreButton: XCUIElement

    private var app: XCUIApplication
    private var feedContainer: XCUIElement
    
    private var commentText: XCUIElement
    private var publishCommentButton: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.feedContainer = self.app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        self.loadMoreButton = self.app.buttons["Load more"].firstMatch
        self.commentText = self.app.textViews.firstMatch
        self.publishCommentButton = self.app.buttons["Post"].firstMatch
    }
    
    convenience init(_ application: XCUIApplication, containerView: XCUIElement) {
        self.init(application)
        feedContainer = containerView
    }
    
    func getCommentsCount() -> UInt {
        return UInt(self.feedContainer.cells.count)
    }
    
    func getComment(_ index: UInt, withScroll scroll: Bool = true) -> Comment {
        let cell = feedContainer.cells.element(boundBy: index)
        
        if scroll {
            scrollToElement(cell, app)
        }
        
        return Comment(cell, app)
    }
    
    func getRandomComment() -> (UInt, Comment) {
        let index = Random.randomUInt(getCommentsCount())
        return (index, getComment(index))
    }
    
    func postNewComment(with text: String) {
        commentText.tap()
        commentText.clearText()
        commentText.typeText(text)
        
        publishCommentButton.tap()
    }
    
    func asUIElement() -> XCUIElement {
        return feedContainer
    }
    
}
