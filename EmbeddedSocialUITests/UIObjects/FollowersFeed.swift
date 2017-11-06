//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class FollowerItem: UICellObject {
    
    var followButton: XCUIElement!
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        followButton = cell.buttons.element
        super.init(application, cell: cell)
    }
    
    func follow() {
        followButton.tap()
    }
    
}

class FollowersFeed: UIFeedObject <FollowerItem> {

    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.tables["UserList"])
    }

    func back() {
        application.navigationBars.children(matching: .button).matching(identifier: "Back").element(boundBy: 0).tap()
    }
    
}
