//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateAccountInteractorTests: XCTestCase {
    var userService: MockUserService!
    var authService: MockAuthService!
    var imagesService: MockImagesService!
    var sut: CreateAccountInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        authService = MockAuthService()
        imagesService = MockImagesService()
        sut = CreateAccountInteractor(userService: userService, imagesService: imagesService, authService: authService)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        authService = nil
        imagesService = nil
        sut = nil
    }
    
    func testThatAccountIsCreated() {
        // given
        let user = User()
            
        // when
        sut.createAccount(for: user) { _ in () }
        
        // then
        XCTAssertEqual(userService.createAccountCount, 1)
    }
}
