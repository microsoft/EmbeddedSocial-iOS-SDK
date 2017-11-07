//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum ActivityFeedSegmentItem: UInt {
    case you
    case following
}

class ActivityFeedSegment: UIObject, UIElementConvertible {
    
    private var feedSegment: XCUIElement
    
    override init(_ application: XCUIApplication) {
        feedSegment = application.segmentedControls.element
        super.init(application)
    }
    
    func select(item: ActivityFeedSegmentItem) {
        feedSegment.buttons.element(boundBy: item.rawValue).tap()
    }
    
    func asUIElement() -> XCUIElement {
        return feedSegment
    }
    
}
