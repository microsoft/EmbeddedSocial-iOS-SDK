//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class HexColorTests: XCTestCase {
    
    func testRGBA_ReverseConversion() {
        let hexString = "#AABBCCDD"
        let color = UIColor(hexString: hexString)
        expect(color.hexString()).to(equal(hexString))
    }
    
    func testRGB_ReverseConversion() {
        let hexString = "#AABBCC"
        let color = UIColor(hexString: hexString)
        expect(color.hexString()).to(equal(hexString + "FF"))
    }
    
    func testRGBA_fromString() {
        let hexString = "#AABBCCDD"
        let color = UIColor(hexString: hexString)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        expect(r * 255) == 0xAA
        expect(g * 255) == 0xBB
        expect(b * 255) == 0xCC
        expect(a * 255) == 0xDD
    }
    
    func testRGB_fromString() {
        let hexString = "#AABBCC"
        let color = UIColor(hexString: hexString)
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        expect(r * 255) == 0xAA
        expect(g * 255) == 0xBB
        expect(b * 255) == 0xCC
    }
    
    func testRGB_fromString_defaultAlphaValue() {
        let hexString = "#AABBCC"
        let color = UIColor(hexString: hexString)
        
        var a: CGFloat = 0
        color.getRed(nil, green: nil, blue: nil, alpha: &a)
        
        expect(a * 255) == 0xFF
    }
}
