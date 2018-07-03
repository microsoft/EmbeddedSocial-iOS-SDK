//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
import Nimble
@testable import EmbeddedSocial

class SinglePostResponseProcessorTests: XCTestCase {
    
    private var sut: SinglePostResponseProcessor!
    var cache: MockCache!
    var operationsBuilder: MockOutgoingCommandOperationsBuilder!
    var predicateBuilder: MockTopicServicePredicateBuilder!
    
    override func setUp() {
        super.setUp()
        
        cache = MockCache()
        operationsBuilder = MockOutgoingCommandOperationsBuilder()
        predicateBuilder = MockTopicServicePredicateBuilder()
        sut = SinglePostResponseProcessor(cache: cache, operationsBuilder: operationsBuilder, predicateBuilder: predicateBuilder)
    }
    
    override func tearDown() {
        super.tearDown()
        cache = nil
        operationsBuilder = nil
        predicateBuilder = nil
    }
    
    func testThatItProcessesFeedResponse() {
        // given
        let response: FeedResponseTopicView = loadResponse(from: "topics&limit20")!
        
        var processedPost: Post?
        
        predicateBuilder.topicActionsRemovedTopicsCreatedCommentsReturnValue = NSPredicate()
        
        let postView = response.data!.first!
        let post = Post(data: postView)!
        let command = MockTopicCommand(topic: post)
        
        let operation = MockFetchOutgoingCommandsOperation(cache: cache, predicate: NSPredicate())
        operation.setCommands([command])
        
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = { operation }
        
        // when
        sut.process(postView, isFromCache: true) { (processedTopic) in
            processedPost = processedTopic.value
        }
        
        // then
        expect(processedPost).toEventuallyNot(beNil())
        
        expect(processedPost?.topicHandle).toEventually(equal(postView.topicHandle))
        
        expect(operation.mainCalled).toEventually(beTrue())
        expect(command.applyToTopicCalled).toEventually(beTrue())
        
        expect(self.operationsBuilder.fetchCommandsOperationPredicateCalled).to(beTrue())
        expect(self.predicateBuilder.topicActionsRemovedTopicsCreatedCommentsCalled).to(beTrue())
    }
    
    func testThatItIgnoresResultsFromAPI() {
        // given

        // when
        var processedPost: Result<Post>?

        sut.process(TopicView(), isFromCache: true) { (processedTopic) in
            processedPost = processedTopic
        }

        // then
        expect(processedPost).toEventuallyNot(beNil())

        expect(self.predicateBuilder.allTopicActionCommandsCalled).toEventually(beFalse())
        expect(self.operationsBuilder.fetchCommandsOperationPredicateCalled).toEventually(beFalse())
        
    }
    
    
}
