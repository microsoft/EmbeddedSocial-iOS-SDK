//
//  PhotoTests.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import XCTest
@testable import MSGP

class PhotoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMementoSerialization() {
        // given
        let photo = Photo(url: "http://google.com")
        
        // when
        let loadedPhoto = Photo(memento: photo.memento)
        
        // then
        XCTAssertNotNil(loadedPhoto)
        XCTAssertEqual(photo, loadedPhoto!)
    }
}
