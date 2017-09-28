//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class ReportCommentOperationTests: XCTestCase {
    
    func testThatItUsesCorrectServiceMethod() {
        // given
        let comment = Comment(commentHandle: UUID().uuidString)
        let command = ReportCommentCommand(comment: comment, reportReason: .other)
        let service = MockReportingService()
        service.reportCommentInputParameters = (comment, .other)
        let sut = ReportCommentOperation(command: command, reportService: service)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertEqual(service.reportCommentCount, 1)
    }
    
}
