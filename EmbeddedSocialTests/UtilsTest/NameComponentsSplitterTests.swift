//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class NameComponentsSplitterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItHandlesTwoComponents() {
        let (firstName, lastName) = NameComponentsSplitter.split(fullName: "John Smith")
        XCTAssertEqual(firstName, "John")
        XCTAssertEqual(lastName, "Smith")
    }
    
    func testThatItHandlesMoreThanTwoComponents() {
        var (firstName, lastName) = NameComponentsSplitter.split(fullName: "John Clark Smith")
        XCTAssertEqual(firstName, "John Clark")
        XCTAssertEqual(lastName, "Smith")
        
        (firstName, lastName) = NameComponentsSplitter.split(fullName: "John Clark Jr. Smith")
        XCTAssertEqual(firstName, "John Clark Jr.")
        XCTAssertEqual(lastName, "Smith")
    }
    
    func testThatItHandlesEmptyInput() {
        let (firstName, lastName) = NameComponentsSplitter.split(fullName: "")
        XCTAssertEqual(firstName, nil)
        XCTAssertEqual(lastName, nil)
    }
}
