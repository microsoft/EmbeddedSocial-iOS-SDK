//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class APIErrorTests: XCTestCase {
    
    func testInitWithNotConnectedError() {
        let e = NSError(domain: NSURLErrorDomain, code: URLError.Code.notConnectedToInternet.rawValue, userInfo: nil)
        let urlError = URLError(_nsError: e)
        let swaggerError = ErrorResponse.HttpError(statusCode: 1, data: nil, error: urlError)
        guard case .notConnectedToInternet = APIError(error: swaggerError) else {
            XCTFail()
            return
        }
    }
}
