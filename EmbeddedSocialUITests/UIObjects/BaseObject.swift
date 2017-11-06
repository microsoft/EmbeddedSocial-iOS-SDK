//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

protocol UIElementConvertible {
    
    func asUIElement() -> XCUIElement
    
}

class UIObject {
    
    var application: XCUIApplication
    
    init(_ application: XCUIApplication) {
        self.application = application
    }
    
    //UILabel values cannot be read when element has an accessibility identifier
    //and should be verified by searching of static texts inside cells
    //https://forums.developer.apple.com/thread/10428
    
    func isExists(text: String) -> Bool {
        return self.cell.staticTexts[text].exists
    }
    
}

class UICellObject: UIObject, UIElementConvertible {
    
    var cell: XCUIElement
    
    init(_ application: XCUIApplication, cell: XCUIElement) {
        super.init(application)
        self.cell = cell
    }
    
    func asUIElement() -> XCUIElement {
        return cell
    }
    
}
