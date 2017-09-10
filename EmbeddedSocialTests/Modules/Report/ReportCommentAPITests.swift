//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportCommentAPITests: XCTestCase {
    
    func testThatItCallsCorrectServiceMethod() {
        // given
        let commentID = UUID().uuidString
        let reason = ReportReason.contentInfringement
        let service = MockReportingService()
        let sut = ReportCommentAPI(commentID: commentID, reportingService: service)
        
        // when
        sut.submitReport(with: reason) { _ in () }
        
        // then
        XCTAssertEqual(service.reportCommentCount, 1)
        XCTAssertEqual(service.reportCommentInputParameters?.commentID, commentID)
        XCTAssertEqual(service.reportCommentInputParameters?.reason, reason)
    }
}
