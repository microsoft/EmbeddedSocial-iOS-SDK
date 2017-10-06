//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class BlockedUserItem {
    
    private var cell: XCUIElement
    private var unblockButton: XCUIElement
    
    init(_ cell: XCUIElement) {
        self.cell = cell
        unblockButton = self.cell.buttons.element
    }
    
    func isExists(text: String) -> Bool {
        return cell.staticTexts[text].exists
    }
    
    func isValidAction() -> Bool {
        return unblockButton.label == "UNBLOCK"
    }
    
    func unblock() {
        unblockButton.tap()
    }
    
}

class BlockedUsersFeed {
    
    private var application: XCUIApplication
    private var blockedUsersTable: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.application = application
        blockedUsersTable = self.application.tables["UserList"]
    }
    
    func getBlockedUsersCount() -> UInt {
        return UInt(blockedUsersTable.cells.count)
    }
    
    func getBlockedUserItem(at index: UInt, withScroll scroll: Bool = true) -> BlockedUserItem {
        let cell = blockedUsersTable.cells.element(boundBy: index)
        
        if scroll {
            scrollToElement(cell, application)
        }
        
        let blockedUserItem = BlockedUserItem(cell)
        return blockedUserItem
    }
    
    func getRandomBlockedUserItem() -> (UInt, BlockedUserItem) {
        let randomIndex = Random.randomUInt(getBlockedUsersCount())
        return (randomIndex, getBlockedUserItem(at: randomIndex))
    }
    
}
