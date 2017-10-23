//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class UpdateNotificationsStatusOperationTests: XCTestCase {
    
    func testExecution() {
        let command = UpdateNotificationsStatusCommand(handle: "1")
        let service = MockActivityNotificationsService()
        let operation = UpdateNotificationsStatusOperation(command: command, notificationsService: service)
        
        service.updateStatusForCompletionResult = .success()
        
        let queue = OperationQueue()
        queue.addOperation(operation)
        queue.waitUntilAllOperationsAreFinished()
        
        expect(service.updateStatusForCompletionCalled).to(beTrue())
        expect(service.updateStatusForCompletionInputHandle).to(equal("1"))
        expect(operation.error).to(beNil())
    }
    
    func testExecutionWithError() {
        let command = UpdateNotificationsStatusCommand(handle: "1")
        let service = MockActivityNotificationsService()
        let operation = UpdateNotificationsStatusOperation(command: command, notificationsService: service)
        
        service.updateStatusForCompletionResult = .failure(APIError.unknown)
        
        let queue = OperationQueue()
        queue.addOperation(operation)
        queue.waitUntilAllOperationsAreFinished()
        
        expect(service.updateStatusForCompletionCalled).to(beTrue())
        expect(service.updateStatusForCompletionInputHandle).to(equal("1"))
        // service errors must be ignored
        expect(operation.error).to(beNil())
    }
}
