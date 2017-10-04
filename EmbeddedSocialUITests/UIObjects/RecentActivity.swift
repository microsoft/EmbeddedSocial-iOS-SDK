//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class RecentActivityItem {
    
    private var application: XCUIApplication
    private var cell: XCUIElement
    
    init(_ application: XCUIApplication, cell: XCUIElement) {
        self.application = application
        self.cell = cell
    }
    
    //UILabel values cannot be read when element has an accessibility identifier
    //and should be verified by searching of static texts inside cells
    //https://forums.developer.apple.com/thread/10428
    
    func isExists(text: String) -> Bool {
        return self.cell.staticTexts[text].exists
    }
    
    func getLabel(with text: String) -> XCUIElement {
        return self.cell.staticTexts[text]
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}

class RecentActivity {
    
    private var application: XCUIApplication
    private var recentActivityTable: XCUIElement
    
    var offset: UInt = 0
    
    init(_ application: XCUIApplication, followRequestsCount: UInt = 0) {
        self.application = application
        recentActivityTable = self.application.tables.element(boundBy: 1)
        offset = followRequestsCount
    }
    
    func getActivitiesCount() -> UInt {
        return recentActivityTable.cells.count - offset
    }
    
    func getActivityItem(at index: UInt, withScroll scroll: Bool = true) -> RecentActivityItem {
        let cell = recentActivityTable.cells.element(boundBy: index + offset)
        
        if scroll {
            scrollToElement(cell, application)
        }
        
        let activityItem = RecentActivityItem(application, cell: cell)
        return activityItem
    }
    
    func getRandomActivityItem() -> (index: UInt, activityItem: RecentActivityItem) {
        let randomIndex = Random.randomUInt(getActivitiesCount()) + offset
        return (randomIndex, getActivityItem(at: randomIndex))
    }
    
}
