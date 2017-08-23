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
    
    func testThatItCachesItemAndLoadsItByHandle() {
        // given
        let item = CacheableItem(handle: UUID().uuidString, name: UUID().uuidString)
        
        // when
        sut.cacheIncoming(item)
        sut.cacheOutgoing(item)
        
        let fetchedIncomingItem = sut.firstIncoming(ofType: CacheableItem.self, handle: item.handle)
        let fetchedOutgoingItem = sut.firstOutgoing(ofType: CacheableItem.self, handle: item.handle)

        // then
        XCTAssertEqual(item, fetchedIncomingItem)
        XCTAssertEqual(item, fetchedOutgoingItem)
    }
    
    func testThatItCachesItemAndLoadsItByPredicate() {
        // given
        let item = CacheableItem(handle: UUID().uuidString, name: UUID().uuidString)
        let predicate = NSPredicate(format: "typeid = %@ AND handle = %@", CacheableItem.typeIdentifier, item.handle)
        
        // when
        sut.cacheIncoming(item)
        sut.cacheOutgoing(item)
        
        let fetchedIncomingItem = sut.firstIncoming(ofType: CacheableItem.self, predicate: predicate, sortDescriptors: [])
        let fetchedOutgoingItem = sut.firstOutgoing(ofType: CacheableItem.self, predicate: predicate, sortDescriptors: [])

        // then
        XCTAssertEqual(fetchedIncomingItem, item)
        XCTAssertEqual(fetchedOutgoingItem, item)
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
    
    func testThatItFetchesIncomingAsyncWithPredicateAndSortDescriptor() {
        // given
        let name = UUID().uuidString
        let itemsWithSameUniqueName = makeItemsWithSameName(name) { $0.handle < $1.handle }
        let items = itemsWithSameUniqueName + makeItems()
        let predicate = NSPredicate(format: "payload.name = %@", name)
        let sortDescriptor = NSSortDescriptor(key: "payload.handle", ascending: true)

        // when
        items.forEach(sut.cacheIncoming)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchIncoming(type: CacheableItem.self, predicate: predicate, sortDescriptors: [sortDescriptor]) { fetchedItems in
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
    
    func testThatItFetchesOutgoingAsyncWithPredicateAndSortDescriptor() {
        // given
        let name = UUID().uuidString
        let itemsWithSameUniqueName = makeItemsWithSameName(name) { $0.handle < $1.handle }
        let items = itemsWithSameUniqueName + makeItems()
        let predicate = NSPredicate(format: "payload.name = %@", name)
        let sortDescriptor = NSSortDescriptor(key: "payload.handle", ascending: true)
        
        // when
        items.forEach(sut.cacheOutgoing)
        
        // then
        let expectation = self.expectation(description: #function)
        
        sut.fetchOutgoing(type: CacheableItem.self, predicate: predicate, sortDescriptors: [sortDescriptor]) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(itemsWithSameUniqueName, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    private func makeItemsWithSameName(_ name: String, sort: (CacheableItem, CacheableItem) -> Bool) -> [CacheableItem] {
        return [
            CacheableItem(handle: UUID().uuidString, name: name),
            CacheableItem(handle: UUID().uuidString, name: name),
            CacheableItem(handle: UUID().uuidString, name: name)
        ].sorted(by: sort)
    }
    
    private func makeItems() -> [CacheableItem] {
        return [
            CacheableItem(handle: UUID().uuidString, name: "A"),
            CacheableItem(handle: UUID().uuidString, name: "B"),
            CacheableItem(handle: UUID().uuidString, name: "C"),
            CacheableItem(handle: UUID().uuidString, name: "D"),
            CacheableItem(handle: UUID().uuidString, name: "E")
        ]
    }
}
