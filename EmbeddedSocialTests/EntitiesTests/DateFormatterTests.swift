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
        
        sut = DateFormatterTool()
        
    }
    
    func testThatFormattingIsCorrect() {
        
        // given
        let cal = Calendar.current
        var comps = DateComponents()
        comps.calendar = cal
        comps.day = -14
        let to = Date()
        let from = cal.date(byAdding: comps, to: to)

        // when
        let result = sut.shortStyle.string(from: from!, to: to)
        
        // then
        XCTAssert(result == "2w")
    }

}


