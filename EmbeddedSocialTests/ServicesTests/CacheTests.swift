//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CacheTests: XCTestCase {
    
    private var coreDataStack: CoreDataStack!
    private var database: MockTransactionsDatabaseFacade!
    private var sut: Cache!
    
    private let timeout: TimeInterval = 5
    
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataHelper.makeEmbeddedSocialInMemoryStack()
        database = MockTransactionsDatabaseFacade(incomingRepo: CoreDataRepository(context: coreDataStack.mainContext),
                                                  outgoingRepo: CoreDataRepository(context: coreDataStack.mainContext))
        sut = Cache(database: database, decoder: CacheableItemDecoder.self)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        database = nil
        sut = nil
    }
    
    func testThatItCachesIncomingItemAndLoadsItByHandle() {
        // given
        let item = CacheableItem(handle: UUID().uuidString, name: UUID().uuidString, relatedHandle: UUID().uuidString)
        
        // when
        sut.cacheIncoming(item)
        let fetchedItem = sut.firstIncoming(ofType: CacheableItem.self, handle: item.handle)
        
        // then
        XCTAssertEqual(fetchedItem, item)
    }
    
    func testThatItCachesOutgoingItemAndLoadsItByHandle() {
        // given
        let item = CacheableItem(handle: UUID().uuidString, name: UUID().uuidString, relatedHandle: UUID().uuidString)
        
        // when
        sut.cacheOutgoing(item)
        let fetchedItem = sut.firstOutgoing(ofType: CacheableItem.self, handle: item.handle)
        
        // then
        XCTAssertEqual(fetchedItem, item)
    }
    
    func testThatItFetchesIncomingTransactionsAndSortsByName() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        
        // when
        items.forEach(sut.cacheIncoming)
        let fetchedItems = sut.fetchIncoming(type: CacheableItem.self, sortDescriptors: [sortDescriptor])
        
        // then
        XCTAssertEqual(items, fetchedItems)
    }
    
    func testThatItFetchesOutgoingTransactionsAndSortsByName() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        
        // when
        items.forEach(sut.cacheOutgoing)
        let fetchedItems = sut.fetchOutgoing(type: CacheableItem.self, sortDescriptors: [sortDescriptor])
        
        // then
        XCTAssertEqual(items, fetchedItems)
    }
    
    func testThatItFetchesIncomingAsync() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        
        // when
        items.forEach(sut.cacheIncoming)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchIncoming(type: CacheableItem.self, sortDescriptors: [sortDescriptor]) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(items, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testThatItFetchesOutgoingAsync() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        
        // when
        items.forEach(sut.cacheOutgoing)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchOutgoing(type: CacheableItem.self, sortDescriptors: [sortDescriptor]) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(items, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    private func makeItems() -> [CacheableItem] {
        return [
            CacheableItem(handle: UUID().uuidString, name: "A", relatedHandle: UUID().uuidString),
            CacheableItem(handle: UUID().uuidString, name: "B", relatedHandle: UUID().uuidString),
            CacheableItem(handle: UUID().uuidString, name: "C", relatedHandle: UUID().uuidString),
            CacheableItem(handle: UUID().uuidString, name: "D", relatedHandle: UUID().uuidString),
            CacheableItem(handle: UUID().uuidString, name: "E", relatedHandle: UUID().uuidString)
        ]
    }
}
