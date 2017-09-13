//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class Comment {
    var app: XCUIApplication
    var cell: XCUIElement
    var teaser: XCUIElement
    var likeButton: XCUIElement
    var replyButton: XCUIElement
    var likesButton: XCUIElement
    var repliesButton: XCUIElement
    
    init(_ cell: XCUIElement, _ application: XCUIApplication) {
        self.app = application
        self.cell = cell
        self.teaser = self.cell.textViews["Teaser"]
        self.likeButton = self.cell.buttons["Like"]
        self.replyButton = self.cell.buttons["Reply"]
        self.likesButton = self.cell.buttons.element(boundBy: 4)
        self.repliesButton = self.cell.buttons.element(boundBy: 5)
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
    
    func like() {
        scrollToElement(self.likeButton, self.app)
        self.likeButton.tap()
        sleep(1)
    }
}

class CommentsFeed {
    var app: XCUIApplication
    var feedContainer: XCUIElement
    var loadMoreButton: XCUIElement
    var commentText: XCUIElement
    var publishCommentButton: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.feedContainer = self.app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        self.loadMoreButton = self.app.buttons["Load more"]
        self.commentText = self.app.textViews["CommentText"]
        self.publishCommentButton = self.app.buttons["Post"]
    }
    
    func getCommentsCount() -> UInt {
        return UInt(self.feedContainer.cells.count - 2)
    }
    
    func getComment(_ index: UInt) -> Comment {
        return Comment(self.feedContainer.children(matching: .cell).element(boundBy: index + 2), self.app)
    }
    
    func getRandomComment() -> (UInt, Comment) {
        let index = Random.randomUInt(self.getCommentsCount())
        return (index, self.getComment(index))
    }
}
