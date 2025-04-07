//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class RecentActivityItem: UICellObject {
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        super.init(application, cell: cell)
    }
    
}

class RecentActivity: UIFeedObject <RecentActivityItem> {
    
    convenience init(_ application: XCUIApplication) {
        self.init(application, feedContainer: application.tables["ActivityFeed"].firstMatch)
    }
    
}
