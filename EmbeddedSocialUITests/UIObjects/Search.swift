//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

enum SearchSegmentItem: String {
    case topics = "Topics"
    case people = "People"
}

class Search: UIObject, UIElementConvertible {
    
    private var searchField: XCUIElement
    private var history: SearchHistory

    override init(_ application: XCUIApplication) {
        searchField = application.searchFields.element
        history = SearchHistory(application)
        super.init(application)
    }
    
    func select(item: SearchSegmentItem) {
        application.buttons[item.rawValue].tap()
    }
    
    func search(_ query: String, for item: SearchSegmentItem) {
        select(item: item)
        
        searchField.tap()
        searchField.typeText(query)
        
        application.keyboards.buttons["Search"].tap()
    }
    
    func clear() {
        searchField.clearText()
    }
    
    func getHistory() -> SearchHistory {
        searchField.clearText()
        return SearchHistory(application)
    }
    
    func asUIElement() -> XCUIElement {
        return searchField
    }
    
}
