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
        
        XCTAssertTrue(storage.setForKeyCalled)
        XCTAssertTrue(storage.objectForKeyCalled)
    }
    
    func testThatItPurgesStorage() {
        // given
        
        // when
        sut.purge(key: className)
        
        // then
        XCTAssertTrue(storage.purgeKeyCalled)
    }
    
    func testThatItRemovesItem() {
        // given
        let item = MementoSerializableItem(uid: UUID().uuidString, name: "Name #\(UUID().uuidString)")

        // when
        sut.save(item, forKey: className)
        sut.remove(forKey: className)
        
        // then
        XCTAssertTrue(storage.setForKeyCalled)
        XCTAssertTrue(storage.removeObjectForKeyCalled)
    }
}
