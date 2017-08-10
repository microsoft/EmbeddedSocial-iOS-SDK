//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Alamofire
@testable import EmbeddedSocial

class UnauthorizedErrorHandlerTests: XCTestCase {
    var logoutController: MockLogoutController!
    var sut: UnauthorizedErrorHandler!
    
    override func setUp() {
        super.setUp()
        logoutController = MockLogoutController()
        sut = UnauthorizedErrorHandler(logoutController: logoutController)
    }
    
    override func tearDown() {
        super.tearDown()
        logoutController = nil
        sut = nil
    }
    
    func testThatItHandlesErrors401() {
        let errors: [Error] = [
            ErrorResponse.HttpError(statusCode: 401, data: nil, error: APIError.unknown),
            AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 401))
        ]
        
        for error in errors {
            XCTAssertTrue(sut.canHandle(error))
        }
    }
    
    func testThatItDoesNotHandleErrorsOtherThanAlamofireAndSwaggerWithCode401() {
        let errors: [Error] = [
            ErrorResponse.HttpError(statusCode: 400, data: nil, error: APIError.unknown),
            AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 400)),
            APIError.unknown
        ]
        
        for error in errors {
            XCTAssertFalse(sut.canHandle(error))
        }
    }
    
    func testThatItHandlesError() {
        // given
        let error = APIError.unknown
        
        // when
        sut.handle(error)
        
        // then
        XCTAssertEqual(logoutController.logOutWithErrorCount, 1)
        XCTAssertEqual(logoutController.logOutCount, 0)
        
        guard let e = logoutController.logOutError as? APIError, case .unknown = e else {
            XCTFail("Invalid error \(logoutController.logOutError.debugDescription), expected \(error)")
            return
        }
    }
}
