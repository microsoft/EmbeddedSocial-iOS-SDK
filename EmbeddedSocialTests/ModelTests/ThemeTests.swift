//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class ThemeTests: XCTestCase {
    
    func testThatLightThemeInitializes() {
        expect(Theme(filename: "light")).notTo(beNil())
    }
}
