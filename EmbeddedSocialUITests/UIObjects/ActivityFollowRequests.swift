//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class FollowRequestItem: UICellObject {
    
    private var profileImage: XCUIElement
    private var acceptButton: XCUIElement
    private var declineButton: XCUIElement
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        profileImage = cell.images.element
        acceptButton = cell.buttons["Accept"].firstMatch
        declineButton = cell.buttons["Reject"].firstMatch
        
        super.init(application, cell: cell)
    }
    
    func accept() {
        acceptButton.tap()
    }
    
    func decline() {
        declineButton.tap()
    }
    
}

class ActivityFollowRequests: UIFeedObject <FollowRequestItem> {
    
    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.tables["ActivityFeed"].firstMatch)
    }
    
}
