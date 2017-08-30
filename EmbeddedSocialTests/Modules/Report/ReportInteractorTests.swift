//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportInteractorTests: XCTestCase {
    var reportingService: MockReportingService!
    var sut: ReportInteractor!
    
    override func setUp() {
        super.setUp()
        reportingService = MockReportingService()
        sut = ReportInteractor(reportingService: reportingService)
    }
    
    override func tearDown() {
        super.tearDown()
        reportingService = nil
        sut = nil
    }
    
    func testThatItSubmitsReport() {
        // given
        let userID = UUID().uuidString
        let reason = ReportReason.contentInfringement
        reportingService.reportReturnValue = .success()
        
        // when
        sut.report(userID: userID, reason: reason) { _ in () }
        
        // then
        XCTAssertEqual(reportingService.reportCount, 1)
        XCTAssertEqual(reportingService.reportInputParameters?.userID, userID)
        XCTAssertEqual(reportingService.reportInputParameters?.reason, reason)
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
