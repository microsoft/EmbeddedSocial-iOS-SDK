//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class ThemePaletteTests: XCTestCase {
    
    func testGivenConfig_thatItLoadsContentBackground() {
        let config = ["contentBackground": "#AABBCCDD"]
        let palette = ThemePalette(config: config, accentColor: UIColor())
        expect(palette.contentBackground.hexString()).to(equal("#AABBCCDD"))
    }
}
