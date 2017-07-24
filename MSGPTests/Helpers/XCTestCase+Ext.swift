//
//  XCTestCase+Ext.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest

extension XCTestCase {
    var className: String {
        return String(describing: type(of: self))
    }
}
