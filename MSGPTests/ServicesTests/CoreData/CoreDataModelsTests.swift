//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import CoreData
@testable import MSGP

class CoreDataModelsTests: XCTestCase {
    private var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataSetupHelper.makeInMemoryCoreDataStack()
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
    }
    
    func testThatIncomingTransactionIsInserted() {
        let transaction = coreDataStack.backgroundContext.create(IncomingTransaction.self)
        XCTAssertNotNil(transaction)
    }
    
    func testThatOutgoingTransactionIsInserted() {
        let transaction = coreDataStack.backgroundContext.create(OutgoingTransaction.self)
        XCTAssertNotNil(transaction)
    }
    
    func testThatIncomingTransactionIsSaved() {
        // given
        var transaction: IncomingTransaction?
        let context = coreDataStack.mainContext

        // when
        context.performAndWait {
            transaction = context.create(IncomingTransaction.self)
            transaction?.handle = UUID().uuidString

            do {
                try context.save()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
        
        XCTAssertNotNil(transaction)
        
        let result: [IncomingTransaction]? = try? context.fetch(IncomingTransaction.fetchRequest())
        let loadedTransaction = result?.first
        
        XCTAssertNotNil(loadedTransaction)

        // then
        XCTAssertEqual(loadedTransaction!.handle, transaction!.handle)
        XCTAssertEqual(loadedTransaction!.createdAt, transaction!.createdAt)
    }
}
