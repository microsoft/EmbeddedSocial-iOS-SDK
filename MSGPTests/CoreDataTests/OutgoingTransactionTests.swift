//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
