//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportReplyAPITests: XCTestCase {
    
    func testThatItCallsCorrectServiceMethod() {
        // given
        let reply = Reply(replyHandle: UUID().uuidString)
        let reason = ReportReason.contentInfringement
        let service = MockReportingService()
        let sut = ReportReplyAPI(reply: reply, reportingService: service)
        
        // when
        sut.submitReport(with: reason) { _ in () }
        
        // then
        XCTAssertEqual(service.reportReplyCount, 1)
        XCTAssertEqual(service.reportReplyInputParameters?.reply.replyHandle, reply.replyHandle)
        XCTAssertEqual(service.reportReplyInputParameters?.reason, reason)
    }
}
