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
        sut = AppConfiguration(filename: "config")
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItInitializesTheme() {
        expect(self.sut.theme).notTo(beNil())
    }
}
