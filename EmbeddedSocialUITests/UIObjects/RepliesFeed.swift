//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

class Reply {
    var app: XCUIApplication
    var cell: XCUIElement
    var likeButton: XCUIElement
    var likesButton: XCUIElement
    
    init(_ cell: XCUIElement, _ application: XCUIApplication) {
        self.app = application
        self.cell = cell
        self.likeButton = self.cell.buttons["Like"]
        self.likesButton = self.cell.buttons.element(boundBy: 3)
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

class RepliesFeed {
    var app: XCUIApplication
    var feedContainer: XCUIElement
    var loadMoreButton: XCUIElement
    var replyText: XCUIElement
    var publishReplyButton: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.app = application
        self.feedContainer = self.app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element
        self.loadMoreButton = self.app.buttons["Load more"]
        self.replyText = self.app.textViews["ReplyText"]
        self.publishReplyButton = self.app.buttons["Post"]
    }
    
    func getRepliesCount() -> UInt {
        return UInt(self.feedContainer.cells.count)
    }
    
    func getReply(_ index: UInt) -> Reply {
        return Reply(self.feedContainer.children(matching: .cell).element(boundBy: index), self.app)
    }
    
    func getRandomReply() -> (UInt, Reply) {
        let index = Random.randomUInt(self.getRepliesCount())
        return (index, self.getReply(index))
    }
}
