//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum ActivityFeedSegmentItem: UInt {
    case you
    case following
}

class ActivityFeedSegment {
    
    private var application: XCUIApplication
    private var feedSegment: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.application = application
        feedSegment = self.application.segmentedControls.element
    }
    
    func select(item: ActivityFeedSegmentItem) {
        feedSegment.buttons.element(boundBy: item.rawValue).tap()
    }
    
}
