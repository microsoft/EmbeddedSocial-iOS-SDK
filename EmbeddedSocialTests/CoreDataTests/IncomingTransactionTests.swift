//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import CoreData
@testable import EmbeddedSocial

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
