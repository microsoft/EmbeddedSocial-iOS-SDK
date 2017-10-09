//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportInteractorTests: XCTestCase {
    var api: MockReportAPI!
    var sut: ReportInteractor!
    
    override func setUp() {
        super.setUp()
        api = MockReportAPI()
        sut = ReportInteractor(api: api)
    }
    
    override func tearDown() {
        super.tearDown()
        api = nil
        sut = nil
    }
    
    func testThatItSubmitsReport() {
        // given
        let reason = ReportReason.contentInfringement
        api.submitReportReturnValue = .success()
        
        // when
        sut.submitReport(with: reason) { _ in () }
        
        // then
        XCTAssertEqual(api.submitReportCount, 1)
        XCTAssertEqual(api.submitReportReceivedReason, reason)
    }
    
    func testThatItReturnsCorrectReportReasonForIndexPath() {
        // given
        let mapping: [IndexPath: ReportReason] = [
            IndexPath(row: 0, section: 0): .virusSpywareMalware,
            IndexPath(row: 1, section: 0): .threatsCyberbullyingHarassment,
            IndexPath(row: 2, section: 0): .childEndangermentExploitation,
            IndexPath(row: 3, section: 0): .offensiveContent,
            IndexPath(row: 4, section: 0): .contentInfringement,
            IndexPath(row: 5, section: 0): .other
        ]
        
        // when
        // then
        for indexPath in mapping.keys {
            let expectedReason = mapping[indexPath]
            let actualReason = sut.reportReason(forIndexPath: indexPath)
            XCTAssertEqual(expectedReason, actualReason)
        }
    }
}
