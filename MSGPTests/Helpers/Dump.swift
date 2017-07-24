//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest

func assertDumpsEqual<T>(_ lhs: @autoclosure () -> T, _ rhs: @autoclosure () -> T) {
    XCTAssertEqual(String(dumping: lhs()), String(dumping: rhs()))
}

func assertDumpsNotEqual<T>(_ lhs: @autoclosure () -> T, _ rhs: @autoclosure () -> T) {
    XCTAssertNotEqual(String(dumping: lhs()), String(dumping: rhs()))
}

extension String {
    init<T>(dumping x: T) {
        self.init()
        dump(x, to: &self)
    }
}
