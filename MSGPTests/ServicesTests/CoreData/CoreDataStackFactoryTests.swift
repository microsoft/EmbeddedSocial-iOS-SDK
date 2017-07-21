//
//  CoreDataStackFactoryTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class CoreDataStackFactoryTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatStackIsCreated() {
        CoreDataSetupHelper.setupInMemoryCoreDataStack { _ = $0 }
    }
}
