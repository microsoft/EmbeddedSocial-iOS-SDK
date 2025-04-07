//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Nimble
import XCTest
@testable import EmbeddedSocial

class MyRecentTopicsFeedResponseProcessorTests: TopicsFeedResponseProcessorTests {
    private var sut: MyRecentTopicsFeedResponseProcessor!
    
    override func setUp() {
        super.setUp()
        sut = MyRecentTopicsFeedResponseProcessor(cache: cache,
                                                  operationsBuilder: operationsBuilder,
                                                  predicateBuilder: predicateBuilder)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testThatItUsesCorrectPredicateForCommandsFetching() {
        // given
        predicateBuilder.allTopicCommandsAndAllCreatedCommentsReturnValue = NSPredicate()
        
        let operation = MockFetchOutgoingCommandsOperation(cache: cache, predicate: NSPredicate())
        operationsBuilder.fetchCommandsOperationPredicateReturnValueMaker = { operation }

        var result: Result<FeedFetchResult>?

        // when
        sut.process(FeedResponseTopicView(), isFromCache: true) { result = $0 }
        
        // then
        expect(result).toEventuallyNot(beNil())
        expect(self.predicateBuilder.allTopicCommandsAndAllCreatedCommentsCalled).toEventually(beTrue())
    }
}
