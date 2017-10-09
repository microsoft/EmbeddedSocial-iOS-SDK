//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum CommentMenuItem: String {
    case follow   = "Follow"
    case unfollow = "Unfollow"
    case block    = "Block"
    case unblock  = "Unblock"
    case report   = "Report comment"
    
    func index() -> UInt {
        switch self {
        case .follow, .unfollow:
            return 0
        case .block, .unblock:
            return 1
        default:
            return 2
        }
    }
}

class CommentMenu {
    
    var isOpened = false
    
    private var application: XCUIApplication
    private var actionSheet: XCUIElement
    
    private var comment: Comment
    
    init(_ application: XCUIApplication, _ comment: Comment) {
        self.application = application
        self.comment = comment
        self.actionSheet = self.application.sheets.element(boundBy: 0)
    }
    
    func isExists(item: CommentMenuItem) -> Bool {
        return actionSheet.buttons[item.rawValue].exists
    }
    
    func select(item: CommentMenuItem) {
        actionSheet.buttons.element(boundBy: item.index()).tap()
        isOpened = false
    }
    
}
