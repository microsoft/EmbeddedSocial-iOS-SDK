//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class AppConfigurationTests: XCTestCase {
    
    var sut: AppConfiguration!
    
    override func setUp() {
        super.setUp()
        sut = AppConfiguration(filename: "test_config")
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItInitializesTheme() {
        let theme = sut.theme
        expect(theme?.palette.contentBackground.hexString()).to(equal("#EEEEEEFF"))
    }
}
