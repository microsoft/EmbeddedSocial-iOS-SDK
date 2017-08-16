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
        sut = Cache(database: database, decoder: ItemDecoder.self)
    }
    
    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        database = nil
        sut = nil
    }
    
    func testThatItCachesIncomingItemAndLoadsItByHandle() {
        // given
        let item = Item(handle: UUID().uuidString, name: UUID().uuidString)
        
        // when
        sut.cacheIncoming(item)
        let fetchedItem = sut.firstIncoming(ofType: Item.self, handle: item.handle)
        
        // then
        XCTAssertEqual(fetchedItem, item)
    }
    
    func testThatItCachesOutgoingItemAndLoadsItByHandle() {
        // given
        let item = Item(handle: UUID().uuidString, name: UUID().uuidString)
        
        // when
        sut.cacheOutgoing(item)
        let fetchedItem = sut.firstOutgoing(ofType: Item.self, handle: item.handle)
        
        // then
        XCTAssertEqual(fetchedItem, item)
    }
    
    func testThatItFetchesIncomingTransactionsAndSortsByName() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        
        // when
        items.forEach(sut.cacheIncoming)
        let fetchedItems = sut.fetchIncoming(type: Item.self, sortDescriptors: [sortDescriptor])
        
        // then
        XCTAssertEqual(items, fetchedItems)
    }
    
    func testThatItFetchesOutgoingTransactionsAndSortsByName() {
        // given
        let items = makeItems()
        let sortDescriptor = NSSortDescriptor(key: "payload.name", ascending: true)
        
        // when
        items.forEach(sut.cacheOutgoing)
        let fetchedItems = sut.fetchOutgoing(type: Item.self, sortDescriptors: [sortDescriptor])
        
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
        
        sut.fetchIncoming(type: Item.self, sortDescriptors: [sortDescriptor]) { fetchedItems in
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
        
        sut.fetchOutgoing(type: Item.self, sortDescriptors: [sortDescriptor]) { fetchedItems in
            XCTAssertTrue(Thread.isMainThread)
            XCTAssertEqual(items, fetchedItems)
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    private func makeItems() -> [Item] {
        return [
            Item(handle: UUID().uuidString, name: "A"),
            Item(handle: UUID().uuidString, name: "B"),
            Item(handle: UUID().uuidString, name: "C"),
            Item(handle: UUID().uuidString, name: "D"),
            Item(handle: UUID().uuidString, name: "E")
        ]
    }
}

extension CacheTests {
    
    struct Item: Cacheable, Equatable {
        let handle: String
        let name: String
        
        func encodeToJSON() -> Any {
            return ["handle": handle, "name": name]
        }
        
        func getHandle() -> String? {
            return handle
        }
        
        static func ==(lhs: Item, rhs: Item) -> Bool {
            return lhs.handle == rhs.handle && lhs.name == rhs.name
        }
    }
    
    struct ItemDecoder: JSONDecoder {
        static func decode<T>(type: T.Type, payload: Any?) -> T? {
            guard T.self is Item.Type,
                let payload = payload as? [String: Any],
                let name = payload["name"] as? String,
                let handle = payload["handle"] as? String else {
                    return nil
            }
            return Item(handle: handle, name: name) as? T
        }
    }
}
