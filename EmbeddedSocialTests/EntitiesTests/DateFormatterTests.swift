//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class DateFormatterTests: XCTestCase {
    
    var sut: DateFormatterTool!

    override func setUp() {
        super.setUp()
        
        sut = DateFormatterTool.shared
    }
    
    func testThatFormattingIsCorrect() {
        
        // given
        let cal = Calendar.current
        var comps = DateComponents()
        comps.calendar = cal
        comps.day = -14
        
        let now: Date = Date()
        let then: Date = cal.date(byAdding: comps, to: now)!
        
        // when
        let result = sut.timeAgo(since: then)
        
        // then
        XCTAssert(result == "2w")
    }
}


