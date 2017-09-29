//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class LinkedAccountsInteractorTests: XCTestCase {
    var sut: LinkedAccountsInteractor!
    var usersService: MockUserService!
    var authService: MockAuthService!
    var sessionToken: String!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
