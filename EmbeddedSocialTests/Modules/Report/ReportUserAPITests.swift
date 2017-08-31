//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportUserAPITests: XCTestCase {
    
    func testThatItCallsCorrectServiceMethod() {
        // given
        let userID = UUID().uuidString
        let reason = ReportReason.contentInfringement
        let service = MockReportingService()
        let sut = ReportUserAPI(userID: userID, reportingService: service)
        
        // when
        sut.submitReport(with: reason) { _ in () }
        
        // then
        XCTAssertEqual(service.reportUserCount, 1)
        XCTAssertEqual(service.reportUserInputParameters?.userID, userID)
        XCTAssertEqual(service.reportUserInputParameters?.reason, reason)
    }
}
