//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class AuthServiceTests: XCTestCase {
    private let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatLoginIsFulfilled() {
        let credentials = CredentialsList(provider: .facebook, accessToken: UUID().uuidString, socialUID: UUID().uuidString)
        let user = SocialUser(credentials: credentials, firstName: nil, lastName: nil, email: nil, photo: nil)
        validateLogin(expectedResult: .success(user))
    }
    
    func testThatLoginIsFailed() {
        let error = NSError(domain: "", code: -1, userInfo: nil)
        validateLogin(expectedResult: .failure(error))
    }
    
    private func validateLogin(expectedResult: Result<SocialUser>) {
        let apiProvider = MockAuthAPIProvider(apiToProvide: MockAuthAPI(resultToReturn: expectedResult))
        let sut = AuthService(apiProvider: apiProvider)
        var loginResult: Result<SocialUser>?
        
        let loginExpectation = expectation(description: "Login expectation")

        sut.login(with: .facebook, from: UIViewController()) { result in
            loginResult = result
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: timeout)
        
        XCTAssertNotNil(loginResult)

        if case let .success(expectedUser) = expectedResult, case let .success(returnedUser) = loginResult! {
            XCTAssertEqual(expectedUser, returnedUser)
        } else if case let .failure(expectedError) = expectedResult, case let .failure(returnedError) = loginResult! {
            XCTAssertEqual(expectedError as NSError, returnedError as NSError)
        } else {
            XCTFail("Login result \(loginResult!) doesn't equal the expected \(expectedResult)")
        }
    }
}
