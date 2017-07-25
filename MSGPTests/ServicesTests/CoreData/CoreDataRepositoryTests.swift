//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class CoreDataRepositoryTests: XCTestCase {
    private var sut: CoreDataRepository<IncomingTransaction>!
    private let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
        let coreDataStack = CoreDataSetupHelper.makeInMemoryCoreDataStack()
        sut = CoreDataRepository<IncomingTransaction>(context: coreDataStack.mainContext)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatEntityIsCreated() {
        // given
        
        // when
        let transaction = sut.create()
        
        // then
        XCTAssertNotNil(transaction)
    }
    
    func testThatEntityCanBeSavedAndLoaded() {
        // given
        let transaction = sut.create()
        transaction.handle = UUID().uuidString
        
        var loadedTransaction: IncomingTransaction?
        let queryExpectation = expectation(description: "Transactions query completed")
        
        // when
        sut.save([transaction])

        sut.query { transactions in
            loadedTransaction = transactions.first
            queryExpectation.fulfill()
        }
        
        // then
        wait(for: [queryExpectation], timeout: timeout)
        
        XCTAssertNotNil(loadedTransaction)
        
        XCTAssertEqual(loadedTransaction!.handle, transaction.handle)
        XCTAssertEqual(loadedTransaction!.createdAt, transaction.createdAt)
    }
    
    func testThatEntityIsDeleted() {
        // given
        let transaction = sut.create()
        var queryExpectation = expectation(description: "Transactions query completed")
        
        // when
        
        sut.save([transaction])
        sut.query { transactions in
            XCTAssertEqual(transactions.count, 1)
            queryExpectation.fulfill()
        }
        wait(for: [queryExpectation], timeout: timeout)
        
        queryExpectation = expectation(description: "Transactions query completed")
        sut.delete([transaction])
        
        // then
        sut.query { transactions in
            XCTAssertTrue(transactions.isEmpty)
            queryExpectation.fulfill()
        }
        
        wait(for: [queryExpectation], timeout: timeout)
    }
}
