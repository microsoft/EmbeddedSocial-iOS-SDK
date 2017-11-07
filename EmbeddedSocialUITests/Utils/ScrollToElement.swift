//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

func scrollToElement(_ element: XCUIElement, _ scrollable: XCUIElement) {
    var retryCount = 10
    while !element.isHittable && retryCount > 0 {
        retryCount -= 1
        scrollable.swipeUp()
    }
}
