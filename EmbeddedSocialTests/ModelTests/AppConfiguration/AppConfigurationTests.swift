//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class AppConfigurationTests: XCTestCase {
    
    func testNormalSetup() {
        guard let theme = Theme(config: ["name": "light"]) else {
            XCTFail()
            return
        }
        expect(AppConfiguration(theme: theme)).notTo(beNil())
    }
}
