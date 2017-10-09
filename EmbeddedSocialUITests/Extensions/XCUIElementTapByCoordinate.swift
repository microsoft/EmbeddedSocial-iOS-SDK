//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import XCTest

extension XCUIElement {
    
    func tapByCoordinate() {
        self.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 1)).tap()
    }
    
}
