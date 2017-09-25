//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

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

extension XCTestCase {
    
    func loadResponse<T>(from file: String) -> T? {
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: file, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let json = try? JSONSerialization.jsonObject(with: data!)
        
        let result = Decoders.decode(clazz: T.self, source: json as AnyObject, instance: nil)
        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            XCTFail("Failed to decode with error \(error)")
            return nil
        }
    }
}


