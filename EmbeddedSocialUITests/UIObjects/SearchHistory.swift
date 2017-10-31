//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

class SearchHistoryItem {
    
    private var application: XCUIApplication
    private var cell: XCUIElement
    
    init(_ application: XCUIApplication, cell: XCUIElement) {
        self.application = application
        self.cell = cell
    }
    
    func getQuery() -> String {
        return cell.staticTexts.firstMatch.label
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}

class SearchHistory {
    
    private var application: XCUIApplication
    private var historyTable: XCUIElement
    
    init(_ application: XCUIApplication) {
        self.application = application
        historyTable = self.application.tables["Search History"].firstMatch
    }
    
    func getHistoryItemsCount() -> UInt {
        return historyTable.cells.count
    }
    
    func getHistoryItem(at index: UInt) -> SearchHistoryItem {
        return SearchHistoryItem(application, cell: historyTable.cells.element(boundBy: index))
    }
    
}
