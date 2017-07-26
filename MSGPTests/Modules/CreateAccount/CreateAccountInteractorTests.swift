//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class CreateAccountInteractorTests: XCTestCase {
    var userService: MockUserService!
    var sut: CreateAccountInteractor!
    
    override func setUp() {
        super.setUp()
        userService = MockUserService()
        sut = CreateAccountInteractor(userService: userService)
    }
    
    override func tearDown() {
        super.tearDown()
        userService = nil
        sut = nil
    }
    
    func testThatAccountIsCreated() {
        // given
        let credentials = CredentialsList(provider: .facebook, accessToken: "", socialUID: "")
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
            
        // when
        sut.createAccount(for: user) { _ in () }
        
        // then
        XCTAssertEqual(userService.createAccountCount, 1)
    }
}
