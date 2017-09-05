//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

extension XCTestCase {
    var className: String {
        return String(describing: type(of: self))
    }
    
    func XCTAssertThrows<ErrorType: Error, T>(expression: @autoclosure () throws -> T, error: ErrorType) where ErrorType: Equatable {
        do {
            _ = try expression()
        } catch let caughtError as ErrorType {
            XCTAssertEqual(caughtError, error)
        } catch {
            XCTFail("Wrong error")
        }
    }
}

extension XCTestCase {
    
    func uniqueString() -> String {
        return UUID().uuidString
    }
    
}
