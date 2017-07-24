//
//  SessionStoreTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/24/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class SessionStoreTests: XCTestCase {
    private var database: MockSessionStoreDatabase!
    private var sut: SessionStore!
    
    override func setUp() {
        super.setUp()
        database = MockSessionStoreDatabase()
        sut = SessionStore(database: database)
    }
    
    override func tearDown() {
        super.tearDown()
        database = nil
        sut = nil
    }
    
    func testExample() {
        
    }
}
