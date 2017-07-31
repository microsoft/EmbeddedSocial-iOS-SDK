//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        self.tap()
        
        let deleteString = stringValue.characters.map { _ in XCUIKeyboardKeyDelete }.joined(separator: "")
        
        self.typeText(deleteString)
    }
}
