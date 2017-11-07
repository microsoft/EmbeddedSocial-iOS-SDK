//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class ReportTopicOperationTests: XCTestCase {
    
    func testExecute() {
        let cmd = ReportTopicCommand(topic: Post(topicHandle: "1"), reason: ._none)
        let service = MockReportingService()
        let op = ReportTopicOperation(command: cmd, service: service)
        
        service.reportPostReturnValue = .success()
        
        let queue = OperationQueue()
        queue.addOperation(op)
        queue.waitUntilAllOperationsAreFinished()
        
        expect(service.reportPostCount).to(equal(1))
        expect(service.reportPostInputParameters?.postID).to(equal("1"))
        expect(service.reportPostInputParameters?.reason).to(equal(cmd.reason))
    }
    
    func testExecuteWithError() {
        let cmd = ReportTopicCommand(topic: Post(topicHandle: "1"), reason: ._none)
        let service = MockReportingService()
        let op = ReportTopicOperation(command: cmd, service: service)
        
        service.reportPostReturnValue = .failure(APIError.unknown)
        
        let queue = OperationQueue()
        queue.addOperation(op)
        queue.waitUntilAllOperationsAreFinished()
        
        expect(service.reportPostCount).to(equal(1))
        expect(service.reportPostInputParameters?.postID).to(equal("1"))
        expect(service.reportPostInputParameters?.reason).to(equal(cmd.reason))
        expect(op.error).to(matchError(APIError.unknown))
    }
    
}
