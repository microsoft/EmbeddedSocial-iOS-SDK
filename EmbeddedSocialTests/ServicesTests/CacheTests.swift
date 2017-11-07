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
        
        Decoders.setupDecoders()
        
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
    
    func testThatItCachesItemAndLoadsItByPredicate() {
        // given
        let item = CacheableItem(handle: UUID().uuidString, name: UUID().uuidString, relatedHandle: UUID().uuidString)
        let predicate = NSPredicate(format: "typeid = %@ AND handle = %@", CacheableItem.typeIdentifier, item.handle)

        // when
        sut.cacheIncoming(item)
        sut.cacheOutgoing(item)
        
        let fetchedIncomingItem = sut.firstIncoming(ofType: CacheableItem.self, predicate: predicate, sortDescriptors: nil)
        let fetchedOutgoingItem = sut.firstOutgoing(ofType: CacheableItem.self, predicate: predicate, sortDescriptors: nil)

        // then
        XCTAssertEqual(item, fetchedIncomingItem)
        XCTAssertEqual(item, fetchedOutgoingItem)
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
    
    func testThatItCachesItemsAndLoadsItByPredicateAndSortDescriptors() {
        // given
        let items = makeItems()
        let lastItem = items.last!
        let predicate = NSPredicate(format: "typeid = %@", CacheableItem.typeIdentifier)
        
        // Sort items in reverse order. The item with the last name is now expected to be returned by cache
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: false)
        
        // when
        items.forEach(sut.cacheIncoming)
        items.forEach(sut.cacheOutgoing)
        
        let fetchedIncomingItem = sut.firstIncoming(ofType: CacheableItem.self, predicate: predicate, sortDescriptors: [sortDescriptor])
        let fetchedOutgoingItem = sut.firstOutgoing(ofType: CacheableItem.self, predicate: predicate, sortDescriptors: [sortDescriptor])
        
        // then
        XCTAssertEqual(fetchedIncomingItem, lastItem)
        XCTAssertEqual(fetchedOutgoingItem, lastItem)
    }
    
    func testThatItFetchesIncomingAndOutgoingTransactionsAndSortsByName() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        let request = CacheFetchRequest(resultType: CacheableItem.self, sortDescriptors: [sortDescriptor])
        
        // when
        items.forEach(sut.cacheIncoming)
        items.forEach(sut.cacheOutgoing)
        
        let fetchedIncomingItems = sut.fetchIncoming(with: request)
        let fetchedOutgoingItems = sut.fetchOutgoing(with: request)
        
        // then
        XCTAssertEqual(items, fetchedIncomingItems)
        XCTAssertEqual(items, fetchedOutgoingItems)
    }
    
    func testThatItFetchesIncomingAsync() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        let request = CacheFetchRequest(resultType: CacheableItem.self, sortDescriptors: [sortDescriptor])
        
        // when
        items.forEach(sut.cacheIncoming)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchIncoming(with: request) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(items, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testThatItFetchesIncomingAsyncWithPredicateAndSortDescriptor() {
        // given
        let name = UUID().uuidString
        let itemsWithSameUniqueName = makeItemsWithSameName(name) { $0.handle < $1.handle }
        let items = itemsWithSameUniqueName + makeItems()
        let predicate = NSPredicate(format: "payload.name = %@", name)
        let sortDescriptor = NSSortDescriptor(key: "payload.handle", ascending: true)
        let request = CacheFetchRequest(resultType: CacheableItem.self, predicate: predicate, sortDescriptors: [sortDescriptor])
        
        // when
        items.forEach(sut.cacheIncoming)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchIncoming(with: request) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(itemsWithSameUniqueName, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testThatItFetchesOutgoingAsync() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        let request = CacheFetchRequest(resultType: CacheableItem.self, sortDescriptors: [sortDescriptor])
        
        // when
        items.forEach(sut.cacheOutgoing)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchOutgoing(with: request) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(items, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testThatItFetchesOutgoingAsyncWithPredicateAndSortDescriptor() {
        // given
        let name = UUID().uuidString
        let itemsWithSameUniqueName = makeItemsWithSameName(name) { $0.handle < $1.handle }
        let items = itemsWithSameUniqueName + makeItems()
        let predicate = NSPredicate(format: "payload.name = %@", name)
        let sortDescriptor = NSSortDescriptor(key: "payload.handle", ascending: true)
        let request = CacheFetchRequest(resultType: CacheableItem.self, predicate: predicate, sortDescriptors: [sortDescriptor])

        // when
        items.forEach(sut.cacheOutgoing)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchOutgoing(with: request) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(itemsWithSameUniqueName, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testThatItDeletesIncomingAndOutgoingItems() {
        // given
        let items = makeItems()
        let predicate = NSPredicate(format: "typeid = %@", CacheableItem.typeIdentifier)
        let request = CacheFetchRequest(resultType: CacheableItem.self, predicate: predicate)
        
        // when
        items.forEach(sut.cacheOutgoing)
        items.forEach(sut.cacheIncoming)
        
        sut.deleteIncoming(with: predicate)
        sut.deleteOutgoing(with: predicate)

        // then
        XCTAssertEqual(sut.fetchIncoming(with: request).count, 0)
        XCTAssertEqual(sut.fetchOutgoing(with: request).count, 0)
    }
    
    private func makeItemsWithSameName(_ name: String, sort: (CacheableItem, CacheableItem) -> Bool) -> [CacheableItem] {
        return [
            CacheableItem(handle: UUID().uuidString, name: name, relatedHandle: UUID().uuidString),
            CacheableItem(handle: UUID().uuidString, name: name, relatedHandle: UUID().uuidString),
            CacheableItem(handle: UUID().uuidString, name: name, relatedHandle: UUID().uuidString)
        ].sorted(by: sort)
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
