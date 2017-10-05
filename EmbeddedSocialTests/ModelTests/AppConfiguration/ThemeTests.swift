//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class ThemeTests: XCTestCase {
    
    func testThatLightThemeInitializes() {
        let palette = ThemePalette(config: [:], accentColor: UIColor())
        expect(Theme(palette: palette)).notTo(beNil())
    }
}
