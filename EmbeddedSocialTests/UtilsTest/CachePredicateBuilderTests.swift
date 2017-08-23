//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CachePredicateBuilderTests: XCTestCase {
    var sut: CachePredicateBuilder!
    
    override func setUp() {
        super.setUp()
        sut = CachePredicateBuilder()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItMakesCorrectTypeIDPredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: "", relatedHandle: "")
        
        // when
        let p = sut.predicate(with: PredicateTestableItem.self)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
    
    func testThatItMakesCorrectTypeIDAndHandlePredicate() {
        // given
        let item = PredicateTestableItem(name: "", handle: UUID().uuidString, relatedHandle: "")
        
        // when
        let p = sut.predicate(with: PredicateTestableItem.self, handle: item.handle)
        
        // then
        XCTAssertTrue(p.evaluate(with: item))
    }
}
