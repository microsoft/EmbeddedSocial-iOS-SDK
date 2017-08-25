//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CachePredicateBuilderTests: XCTestCase {
    var sut: PredicateBuilder!
    
    override func setUp() {
        super.setUp()
        sut = PredicateBuilder()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItMakesCorrectHandlePredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: UUID().uuidString, relatedHandle: "")
        
        // when
        let p = sut.predicate(handle: item.handle)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
    
    func testThatItMakesCorrectTypeIDPredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: "", relatedHandle: "")
        
        // when
        let p = sut.predicate(typeID: item.typeid)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
    
    func testThatItMakesCorrectTypeIDAndHandlePredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: UUID().uuidString, relatedHandle: "")
        
        // when
        let p = sut.predicate(typeID: item.typeid, handle: item.handle)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
    
    func testThatItMakesCorrectTypeIDHandleAndRelatedHandlePredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: UUID().uuidString, relatedHandle: UUID().uuidString)
        
        // when
        let p = sut.predicate(typeID: item.typeid, handle: item.handle, relatedHandle: item.relatedHandle)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
    
    func testThatItMakesCorrectTypeIDAndRelatedHandlePredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: "", relatedHandle: UUID().uuidString)
        
        // when
        let p = sut.predicate(typeID: item.typeid, relatedHandle: item.relatedHandle)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
}
