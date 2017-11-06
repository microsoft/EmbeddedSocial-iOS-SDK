//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

// MARK: - Protocols

protocol UIElementConvertible {
    
    func asUIElement() -> XCUIElement
    
}

protocol Indexable {
    
    func index() -> UInt
    
}

// MARK: - UIObject

class UIObject {
    
    var application: XCUIApplication
    
    init(_ application: XCUIApplication) {
        self.application = application
    }
    
}

// MARK: - Feed objects

class UICellObject: UIObject, UIElementConvertible {
    
    var cell: XCUIElement
    
    required init(_ application: XCUIApplication, cell: XCUIElement) {
        self.cell = cell
        super.init(application)
    }
    
    func getLabelByText(_ text: String) -> XCUIElement {
        return cell.staticTexts[text]
    }
    
    func isExists(_ text: String) -> Bool {
        return cell.staticTexts[text].exists
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}

class UIFeedObject <T: UICellObject>: UIObject, UIElementConvertible {
    
    var feedContainer: XCUIElement
    
    init(_ application: XCUIApplication, feedContainer: XCUIElement) {
        self.feedContainer = feedContainer
        super.init(application)
    }
    
    func getRandomItem(_ withScroll: Bool = true) -> (index: UInt, item: T) {
        let randomIndex = Random.randomUInt(getItemsCount())
        return (randomIndex, getItem(at: randomIndex, withScroll: withScroll))
    }
    
    func getItem(at index: UInt, withScroll: Bool = true) -> T {
        let cell = feedContainer.cells.element(boundBy: index)
        
        if withScroll {
            scrollToElement(cell, application)
        }
        
        let item = T(application, cell: cell)
        return item
    }
    
    func getItemsCount() -> UInt {
        return feedContainer.cells.count
    }
    
    func asUIElement() -> XCUIElement {
        return feedContainer
    }
    
}

// MARK: - Menu

class UIMenuObject <T: UICellObject, V: RawRepresentable & Indexable>: UIObject where V.RawValue == String {
    
    var isOpened = false
    var actionSheet: XCUIElement
    
    var item: T
    
    init(_ application: XCUIApplication, item: T) {
        self.item = item
        actionSheet = application.sheets.element
        super.init(application)
    }
    
    func isExists(item: V) -> Bool {
        return actionSheet.buttons[item.rawValue].exists
    }
    
    func select(item: V) {
        actionSheet.buttons.element(boundBy: item.index()).tap()
        isOpened = false
    }
    
}
