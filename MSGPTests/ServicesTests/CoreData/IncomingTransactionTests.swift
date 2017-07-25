//
//  IncomingTransactionTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
import CoreData
@testable import MSGP

class IncomingTransactionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItHasCorrectEntityName() {
        // given
        let entityName = IncomingTransaction.entityName
        let fetchRequest: NSFetchRequest<IncomingTransaction> = IncomingTransaction.fetchRequest()
        
        // when
        
        // then
        XCTAssertEqual(entityName, "IncomingTransaction")
        XCTAssertEqual(fetchRequest.entityName, "IncomingTransaction")
    }
}
