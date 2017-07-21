//
//  CoreDataModelsTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
import CoreData
@testable import MSGP

class CoreDataModelsTests: XCTestCase {
    private var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        CoreDataSetupHelper.setupInMemoryCoreDataStack { self.coreDataStack = $0 }
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
            transaction?.handle = "123"

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
