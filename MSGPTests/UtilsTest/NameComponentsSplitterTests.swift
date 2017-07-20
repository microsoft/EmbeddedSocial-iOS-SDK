//
//  NameComponentsSplitterTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/12/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

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
