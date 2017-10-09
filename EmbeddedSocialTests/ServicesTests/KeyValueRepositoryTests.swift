//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class KeyValueRepositoryTests: XCTestCase {
    var storage: MockKeyValueStorage!
    var sut: KeyValueRepository<MementoSerializableItem>!
    
    override func setUp() {
        super.setUp()
        storage = MockKeyValueStorage()
        sut = KeyValueRepository<MementoSerializableItem>(storage: storage)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        storage = nil
    }
    
    func testThatItSavesAndLoadsItem() {
        // given
        let item = MementoSerializableItem(uid: UUID().uuidString, name: "Name #\(UUID().uuidString)")
        
        // when
        sut.save(item, forKey: className)
        
        // then
        _ = sut.load(forKey: className)
        XCTAssertEqual(storage.setObjectCount, 1)
        XCTAssertEqual(storage.getObjectCount, 1)
    }
    
    func testThatItPurgesStorage() {
        // given
        
        // when
        sut.purge(key: className)
        
        // then
        XCTAssertEqual(storage.purgeObjectCount, 1)
    }
    
    func testThatItRemovesItem() {
        // given
        let item = MementoSerializableItem(uid: UUID().uuidString, name: "Name #\(UUID().uuidString)")

        // when
        sut.save(item, forKey: className)
        sut.remove(forKey: className)
        
        // then
        XCTAssertEqual(storage.setObjectCount, 1)
        XCTAssertEqual(storage.removeObjectCount, 1)
    }
}
