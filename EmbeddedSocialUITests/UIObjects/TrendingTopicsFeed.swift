//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class TrendingTopicItem {
    
    private var application: XCUIApplication
    private var cell: XCUIElement
    
    init(_ application: XCUIApplication, cell: XCUIElement) {
        self.application = application
        self.cell = cell
    }
    
    func getName() -> String {
        return cell.staticTexts.firstMatch.label
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}

class TrendingTopicsFeed {
    
    private var application: XCUIApplication
    private var topicsTable: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.application = application
        topicsTable = self.application.tables["TrendingTopics"].firstMatch
    }
    
    func getTopic(at index: UInt) -> TrendingTopicItem {
        let cell = topicsTable.cells.element(boundBy: index)
        return TrendingTopicItem(application, cell: cell)
    }
    
    func getRandomTopic() -> (index: UInt, topic: TrendingTopicItem) {
        let index = Random.randomUInt(topicsTable.cells.count)
        return (index, getTopic(at: index))
    }
    
    func asUIElement() -> XCUIElement {
        return topicsTable
    }
    
}
