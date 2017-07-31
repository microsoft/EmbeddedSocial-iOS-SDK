//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class URLSchemeServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatURLIsHandled() {
        // given
        let service1 = URLSchemeService(schemes: [MockURLScheme(result: true), MockURLScheme(result: false)])
        let service2 = URLSchemeService(schemes: [MockURLScheme(result: false)])
        let service3 = URLSchemeService(schemes: [])
        let service4 = URLSchemeService(schemes: [MockURLScheme(result: true)])

        guard let url = URL(string: "http://google.com") else {
            XCTFail()
            return
        }
        
        // when
        
        
        // then
        XCTAssertTrue(service1.application(UIApplication.shared, open: url))
        XCTAssertFalse(service2.application(UIApplication.shared, open: url))
        XCTAssertFalse(service3.application(UIApplication.shared, open: url))
        XCTAssertTrue(service4.application(UIApplication.shared, open: url))
    }
}
