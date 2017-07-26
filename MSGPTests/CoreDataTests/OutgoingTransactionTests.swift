//
//  OutgoingTransactionTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
import CoreData
@testable import MSGP

class OutgoingTransactionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItHasCorrectEntityName() {
        // given
        let entityName = OutgoingTransaction.entityName
        let fetchRequest: NSFetchRequest<OutgoingTransaction> = OutgoingTransaction.fetchRequest()
        
        // when
        
        // then
        XCTAssertEqual(entityName, "OutgoingTransaction")
        XCTAssertEqual(fetchRequest.entityName, "OutgoingTransaction")
    }
}
