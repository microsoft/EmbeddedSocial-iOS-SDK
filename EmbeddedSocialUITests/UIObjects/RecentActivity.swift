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
        return self.cell.staticTexts.element.label.lowercased().contains(text.lowercased())
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
    
    init(_ application: XCUIApplication) {
        self.application = application
        recentActivityTable = self.application.tables["ActivityFeed"].firstMatch
    }
    
    func getActivitiesCount() -> UInt {
        return recentActivityTable.cells.matching(identifier: "ActivityCell").count
    }
    
    func getActivityItem(at index: UInt, withScroll scroll: Bool = true) -> RecentActivityItem {
        let cell = recentActivityTable.cells.matching(identifier: "ActivityCell").element(boundBy: index)
        
        if scroll {
            scrollToElement(cell, application)
        }
        
        let activityItem = RecentActivityItem(application, cell: cell)
        return activityItem
    }
    
    func getRandomActivityItem() -> (index: UInt, activityItem: RecentActivityItem) {
        let randomIndex = Random.randomUInt(getActivitiesCount())
        return (randomIndex, getActivityItem(at: randomIndex))
    }
    
    func asUIElement() -> XCUIElement {
        return recentActivityTable
    }
    
}
