//
//  TransactionsDatabaseFacadeTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/25/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class TransactionsDatabaseFacadeTests: XCTestCase {
    private var incomingRepo: MockQueriableRepository<IncomingTransaction>!
    private var outgoingRepo: MockQueriableRepository<OutgoingTransaction>!
    private var sut: TransactionsDatabaseFacade!
    private var coreDataStack: CoreDataStack!
    
    private let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataSetupHelper.makeInMemoryCoreDataStack()
        incomingRepo = MockQueriableRepository()
        outgoingRepo = MockQueriableRepository()
        sut = TransactionsDatabaseFacade(incomingRepo: incomingRepo, outgoingRepo: outgoingRepo)
    }
    
    override func tearDown() {
        super.tearDown()
        
        coreDataStack = nil
        incomingRepo = nil
        outgoingRepo = nil
        sut = nil
    }
    
    func testThatItSavesIncomingTransaction() {
        // given
        let transaction = coreDataStack.mainContext.create(IncomingTransaction.self)
        
        // when
        sut.save(transaction: transaction)
        
        // then
        XCTAssertEqual(incomingRepo.saveCount, 1)
        XCTAssertEqual(outgoingRepo.saveCount, 0)
    }
    
    func testThatItLoadsIncomingTransaction() {
        // given
        let handle = UUID().uuidString
        let payload = [UUID().uuidString: UUID().uuidString]
        
        let transaction = coreDataStack.mainContext.create(IncomingTransaction.self)
        transaction.handle = handle
        transaction.payload = payload
        
        // when
        sut.save(transaction: transaction)
    }
    
    func testThatItQueriesIncomingTransactions() {
        // given
        let transaction = coreDataStack.mainContext.create(IncomingTransaction.self)
        incomingRepo.itemsToQuery = [transaction]

        // when
        sut.save(transaction: transaction)
        
        let transactionsFetchedExpectation = expectation(description: "Transactions fetched")
        var fetchedTransactions: [IncomingTransaction] = []
        sut.queryIncomingTransactions { transactions in
            fetchedTransactions = transactions
            transactionsFetchedExpectation.fulfill()
        }
        wait(for: [transactionsFetchedExpectation], timeout: timeout)
        
        // then
        XCTAssertEqual(incomingRepo.queryCount, 1)
        XCTAssertEqual(fetchedTransactions, incomingRepo.itemsToQuery)
    }
    
    func testThatItDeletesIncomingTransaction() {
        // given

        // when
        sut.deleteIncomingTransactions([], completion: nil)
        
        // then
        XCTAssertEqual(outgoingRepo.deleteCount, 0)
        XCTAssertEqual(incomingRepo.deleteCount, 1)
    }
    
    func testThatItMakesIncomingTransaction() {
        // given
        let transaction = coreDataStack.mainContext.create(IncomingTransaction.self)
        incomingRepo.itemToCreate = transaction
        
        // when
        let createdTransaction = sut.makeIncomingTransaction()
        
        // then
        XCTAssertEqual(transaction, createdTransaction)
        XCTAssertEqual(incomingRepo.createCount, 1)
    }
    
    func testThatItSavesOutgoingTransaction() {
        // given
        let transaction = coreDataStack.mainContext.create(OutgoingTransaction.self)
        
        // when
        sut.save(transaction: transaction)
        
        // then
        XCTAssertEqual(incomingRepo.saveCount, 0)
        XCTAssertEqual(outgoingRepo.saveCount, 1)
    }
    
    func testThatItLoadsOutgoingTransaction() {
        // given
        let handle = UUID().uuidString
        let payload = [UUID().uuidString: UUID().uuidString]
        
        let transaction = coreDataStack.mainContext.create(OutgoingTransaction.self)
        transaction.handle = handle
        transaction.payload = payload
        
        // when
        sut.save(transaction: transaction)
    }
    
    func testThatItQueriesOutgoingTransactions() {
        // given
        let transaction = coreDataStack.mainContext.create(OutgoingTransaction.self)
        outgoingRepo.itemsToQuery = [transaction]

        // when
        sut.save(transaction: transaction)
        
        let transactionsFetchedExpectation = expectation(description: "Transactions fetched")
        var fetchedTransactions: [OutgoingTransaction] = []
        sut.queryOutgoingTransactions { transactions in
            fetchedTransactions = transactions
            transactionsFetchedExpectation.fulfill()
        }
        wait(for: [transactionsFetchedExpectation], timeout: timeout)
        
        // then
        XCTAssertEqual(outgoingRepo.queryCount, 1)
        XCTAssertEqual(fetchedTransactions, outgoingRepo.itemsToQuery)
    }
    
    func testThatItDeletesOutgoingTransaction() {
        // given
        
        // when
        sut.deleteOutgoingTransactions([], completion: nil)
        
        // then
        XCTAssertEqual(outgoingRepo.deleteCount, 1)
        XCTAssertEqual(incomingRepo.deleteCount, 0)
    }
    
    func testThatItMakesOutgoingTransaction() {
        // given
        let transaction = coreDataStack.mainContext.create(OutgoingTransaction.self)
        outgoingRepo.itemToCreate = transaction
        
        // when
        let createdTransaction = sut.makeOutgoingTransaction()
        
        // then
        XCTAssertEqual(transaction, createdTransaction)
        XCTAssertEqual(outgoingRepo.createCount, 1)
    }
}
