//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class ReplyItem: UICellObject {
    
    var likeButton: XCUIElement
    var likesButton: XCUIElement

    required init(_ application: XCUIApplication, cell: XCUIElement) {
        likeButton = cell.buttons["Like Reply"].firstMatch
        likesButton = cell.buttons["Likes Reply"].firstMatch
        super.init(application, cell: cell)
    }
    
    func like() {
        scrollToElement(likeButton, application)
        likeButton.tap()
        sleep(1)
    }
    
}

class RepliesFeed: UIFeedObject <ReplyItem> {
    
    var loadMoreButton: XCUIElement
    var replyText: XCUIElement
    var publishReplyButton: XCUIElement
    
    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element)
    }
    
    override init(_ application: XCUIApplication, feedContainer: XCUIElement) {
        loadMoreButton = application.buttons["Load more"]
        replyText = application.textViews["ReplyText"]
        publishReplyButton = application.buttons["Post"]
        super.init(application, feedContainer: feedContainer)
    }
    
    func publishWith(text: String) {
        replyText.tap()
        replyText.clearText()
        replyText.tap()
        replyText.typeText(text)
        
        publishReplyButton.tap()
    }
    
}
