//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class OutgoingCommandsUploadStrategyTests: XCTestCase {
    typealias Step = OutgoingCommandsUploadStrategy.Step

    var queue: MockOperationQueue!
    var cache: MockCache!
    var operationsBuilder: MockOutgoingCommandOperationsBuilder!
    var predicateBuilder: MockOutgoingCommandsPredicateBuilder!
    var delegate: MockOutgoingCommandsUploadStrategyDelegate!
    var sut: OutgoingCommandsUploadStrategy!
    
    override func setUp() {
        super.setUp()
        
        queue = MockOperationQueue()
        cache = MockCache()
        operationsBuilder = MockOutgoingCommandOperationsBuilder()
        predicateBuilder = MockOutgoingCommandsPredicateBuilder()
        delegate = MockOutgoingCommandsUploadStrategyDelegate()
        sut = OutgoingCommandsUploadStrategy(cache: cache, operationsBuilderType: operationsBuilder,
                                             executionQueue: queue, predicateBuilder: predicateBuilder)
        sut.delegate = delegate
    }
    
    override func tearDown() {
        super.tearDown()
        queue = nil
        cache = nil
        sut = nil
        operationsBuilder = nil
        predicateBuilder = nil
        delegate = nil
    }
    
    func testThatItCancelsSubmission() {
        sut.cancelSubmission()
        XCTAssertTrue(queue.cancelAllOperationsCalled)
    }
    
    func testThatItRestartsSubmission() {
        // given
        let submissionStepsCount = 8
        let predicate = NSPredicate()
        var createdFetchOperations: [MockFetchOutgoingCommandsOperation] = []
        let commands = [MockOutgoingCommand(uid: UUID().uuidString), MockOutgoingCommand(uid: UUID().uuidString)]
        
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = { [unowned self] in
            let op = MockFetchOutgoingCommandsOperation(cache: self.cache, predicate: predicate)
            op.setCommands(commands)
            createdFetchOperations.append(op)
            return op
        }
        
        operationsBuilder.operationForCommandReturnValueMaker = { MockOutgoingCommandOperation() }
        
        cache.deleteOutgoing_Expectation.expectedFulfillmentCount = UInt(submissionStepsCount * commands.count)
        cache.deleteOutgoing_Expectation.assertForOverFulfill = true
        
        predicateBuilder.predicateForReturnValue = NSPredicate()

        // when
        sut.restartSubmission()
        
        // then
        wait(for: [cache.deleteOutgoing_Expectation], timeout: 1.0)

        XCTAssertTrue(queue.cancelAllOperationsCalled)
        createdFetchOperations.forEach { XCTAssertTrue($0.mainCalled) }
        
        XCTAssertTrue(operationsBuilder.fetchCommandsOperationPredicateCalled)
        XCTAssertTrue(operationsBuilder.operationForCommandCalled)
    }
    
    func testThatItRestartsSubmissionWhenOperationFails() {
        // given
        let predicate = NSPredicate()
        let commands = [MockOutgoingCommand(uid: UUID().uuidString)]
        
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = { [unowned self] in
            let op = MockFetchOutgoingCommandsOperation(cache: self.cache, predicate: predicate)
            op.setCommands(commands)
            return op
        }
        
        operationsBuilder.operationForCommandReturnValueMaker = {
            print("operationsBuilder.operationForCommandReturnValueMaker")
            let op = MockOutgoingCommandOperation()
            op.setError(APIError.unknown)
            return op
        }
        
        cache.deleteOutgoing_Expectation.isInverted = true
        
        // when
        sut.delegate = delegate
        sut.restartSubmission()
        
        // then
        wait(for: [cache.deleteOutgoing_Expectation], timeout: 1.0)
        XCTAssertFalse(cache.deleteOutgoing_with_Called)
    }
    
    func testSubmissionSteps() {
        validateSubmissionStep(.images, predicate: PredicateBuilder().allImageCommands(), nextStep: .createTopics)
        
        validateSubmissionStep(.createTopics, predicate: PredicateBuilder().createDeleteTopicCommands(), nextStep: .topicActions)
        
        validateSubmissionStep(.topicActions, predicate: PredicateBuilder().allTopicActionCommands(), nextStep: .createDeleteComments)
        
        validateSubmissionStep(.createDeleteComments, predicate: PredicateBuilder().createDeleteCommentCommands(), nextStep: .commentActions)
        
        validateSubmissionStep(.commentActions, predicate: PredicateBuilder().commentActionCommands(), nextStep: .createDeleteReplies)
        
        validateSubmissionStep(.createDeleteReplies, predicate: PredicateBuilder().createDeleteReplyCommands(), nextStep: .replyActions)
        
        validateSubmissionStep(.replyActions, predicate: PredicateBuilder().replyActionCommands(), nextStep: .userActions)
        
        validateSubmissionStep(.userActions, predicate: PredicateBuilder().allUserCommands(), nextStep: nil)
    }
    
    private func validateSubmissionStep(_ step: Step, predicate: NSPredicate, nextStep: Step?) {
        XCTAssertEqual(step.predicate, predicate)
        XCTAssertEqual(step.next, nextStep)
    }
}



