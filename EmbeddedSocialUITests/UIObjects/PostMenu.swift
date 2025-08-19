//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum PostMenuItem: String, Indexable {
    case follow   = "Follow"
    case unfollow = "Unfollow"
    case block    = "Block"
    case unblock  = "Unblock"
    case report   = "Report post"
    case hide     = "Hide"
    case cancel   = "Cancel"
    
    // Items for an own post
    
    case edit     = "Edit post"
    case remove   = "Remove post"
    
    func index() -> UInt {
        switch self {
        case .follow, .unfollow, .edit:
            return 0
        case .block, .unblock, .remove:
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

class PostMenu: UIMenuObject <PostItem, PostMenuItem> {
    
    override init(_ application: XCUIApplication, item: PostItem) {
        super.init(application, item: item)
    }
    
}
