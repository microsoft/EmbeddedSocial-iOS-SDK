//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportPostAPITests: XCTestCase {
    
    func testThatItCallsCorrectServiceMethod() {
        // given
        let postID = UUID().uuidString
        let reason = ReportReason.contentInfringement
        let service = MockReportingService()
        let sut = ReportPostAPI(postID: postID, reportingService: service)
        
        // when
        sut.submitReport(with: reason) { _ in () }
        
        // then
        XCTAssertEqual(service.reportPostCount, 1)
        XCTAssertEqual(service.reportPostInputParameters?.postID, postID)
        XCTAssertEqual(service.reportPostInputParameters?.reason, reason)
    }
}
