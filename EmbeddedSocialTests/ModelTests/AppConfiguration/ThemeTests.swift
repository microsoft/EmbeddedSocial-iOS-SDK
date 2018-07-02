//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class ThemeTests: XCTestCase {
    
    func testNormalSetup() {
        let config = ["name": "dark", "accentColor": "#ffffff"]
        expect(Theme(config: config)).notTo(beNil())
    }
    
    func testSetupWithoutAccent() {
        let config = ["name": "dark"]
        expect(Theme(config: config)).notTo(beNil())
    }
    
    func testDefaultAccentColor() {
        let config = ["name": "dark"]
        let theme = Theme(config: config)
        expect(theme?.palette.accent).to(equal(UIColor(hexString: "")))
    }
    
    func testSetupWithInvalidConfig() {
        let config1: [String: Any] = [:]
        expect(Theme(config: config1)).to(beNil())
        
        let config2 = ["accentColor": "#ffffff"]
        expect(Theme(config: config2)).to(beNil())
    }
}
