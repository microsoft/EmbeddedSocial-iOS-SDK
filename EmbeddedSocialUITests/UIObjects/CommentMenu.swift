//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum CommentMenuItem: String, Indexable {
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

class CommentMenu: UIMenuObject <CommentItem, CommentMenuItem> {
    
    override init(_ application: XCUIApplication, item: CommentItem) {
        super.init(application, item: item)
    }
    
}
