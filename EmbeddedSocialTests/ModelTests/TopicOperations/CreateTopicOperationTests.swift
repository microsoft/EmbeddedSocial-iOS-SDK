//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateTopicOperationTests: XCTestCase {
    
    var handleUpdater: MockRelatedHandleUpdater!
    var predicateBuilder: MockOutgoingCommandsPredicateBuilder!
    
    override func setUp() {
        super.setUp()
        handleUpdater = MockRelatedHandleUpdater()
        predicateBuilder = MockOutgoingCommandsPredicateBuilder()
    }
    
    override func tearDown() {
        super.tearDown()
        handleUpdater = nil
        predicateBuilder = nil
    }
    
    func testThatItUsesCorrectServiceMethodAndUpdatesRelatedHandle() {
        // given
        let oldTopic = Post(topicHandle: UUID().uuidString)
        let createdTopic = Post(topicHandle: UUID().uuidString)
        let command = CreateTopicCommand(topic: oldTopic)
        
        let service = PostServiceMock()
        service.postTopicReturnTopic = createdTopic
        
        let predicate = NSPredicate()
        predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDReturnValue = predicate
        
        let sut = CreateTopicOperation(command: command, topicsService: service,
                                       predicateBuilder: predicateBuilder, handleUpdater: handleUpdater)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        // correct service method called
        XCTAssertTrue(service.postTopicCalled)
        
        // predicate is built
        XCTAssertTrue(predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDCalled)
        let predicateBuilderArgs = predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDReceivedArguments
        XCTAssertEqual(predicateBuilderArgs?.relatedHandle, oldTopic.topicHandle)
        XCTAssertEqual(predicateBuilderArgs?.ignoredTypeID, command.typeIdentifier)
        
        // related handle updated
        XCTAssertTrue(handleUpdater.updateRelatedHandleFromToPredicateCalled)
        let handleUpdaterArgs = handleUpdater.updateRelatedHandleFromToPredicateReceivedArguments
        XCTAssertEqual(handleUpdaterArgs?.oldHandle, oldTopic.topicHandle)
        XCTAssertEqual(handleUpdaterArgs?.newHandle, createdTopic.topicHandle)
        XCTAssertEqual(handleUpdaterArgs?.predicate, predicate)
    }
    
    func testThatItFinishesWithErrorWhenServiceFailsToCreateTopic() {
        // given
        let service = PostServiceMock()
        service.postTopicError = APIError.unknown
        
        let topic = Post(topicHandle: UUID().uuidString)
        let command = CreateTopicCommand(topic: topic)

        let sut = CreateTopicOperation(command: command, topicsService: service,
                                       predicateBuilder: predicateBuilder, handleUpdater: handleUpdater)
        
        // when
        let queue = OperationQueue()
        queue.addOperation(sut)
        queue.waitUntilAllOperationsAreFinished()
        
        // then
        XCTAssertTrue(service.postTopicCalled)
        
        XCTAssertFalse(predicateBuilder.commandsWithRelatedHandleIgnoredTypeIDCalled)
        
        XCTAssertFalse(handleUpdater.updateRelatedHandleFromToPredicateCalled)
        
        guard let resultError = sut.error as? APIError, case APIError.unknown = resultError else {
            XCTFail("Must contain error returned from service")
            return
        }
    }
}
