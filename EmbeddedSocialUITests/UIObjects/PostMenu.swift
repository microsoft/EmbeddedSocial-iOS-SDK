//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum PostMenuItem: String {
    case follow   = "Follow"
    case unfollow = "Unfollow"
    case block    = "Block"
    case unblock  = "Unblock"
    case report   = "Report"
    case hide     = "Hide"
    case cancel   = "Cancel"
    
    func index() -> UInt {
        switch self {
        case .follow, .unfollow:
            return 0
        case .block, .unblock:
            return 1
        case .report:
            return 2
        case .hide:
            return 3
        default:
            return 4
        }
    }
}

class PostMenu {
    
    var isOpened = false
    
    private var application: XCUIApplication
    private var actionSheet: XCUIElement
    
    private var post: Post
    
    init(_ application: XCUIApplication, _ post: Post) {
        self.application = application
        self.post = post
        self.actionSheet = self.application.sheets.element(boundBy: 0)
    }
    
    func isExists(item: PostMenuItem) -> Bool {
        return actionSheet.buttons[item.rawValue].exists
    }
    
    func select(item: PostMenuItem) {
        actionSheet.buttons.element(boundBy: item.index()).tap()
        isOpened = false
    }
    
}
