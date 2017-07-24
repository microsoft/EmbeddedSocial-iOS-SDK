//
//  Dump.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
