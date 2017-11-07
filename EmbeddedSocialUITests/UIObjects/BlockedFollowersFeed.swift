//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BlockedUserItem: UICellObject {
    
    private var unblockButton: XCUIElement
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        unblockButton = cell.buttons.element
        super.init(application, cell: cell)
    }
    
    func isValidAction() -> Bool {
        return unblockButton.label == "UNBLOCK"
    }
    
    func unblock() {
        unblockButton.tap()
    }
    
}

class BlockedUsersFeed: UIFeedObject <BlockedUserItem> {
    
    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.tables["UserList"])
    }
    
}
