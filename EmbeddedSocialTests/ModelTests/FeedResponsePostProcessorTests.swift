//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class FeedResponsePostProcessorTests: XCTestCase {
    
    var cache: MockCache!
    var predicateBuilder: MockTopicServicePredicateBuilder!
    var sut: FeedResponsePostProcessor!
    
    override func setUp() {
        super.setUp()
        cache = MockCache()
        predicateBuilder = MockTopicServicePredicateBuilder()
        sut = FeedResponsePostProcessor(cache: cache, predicateBuilder: predicateBuilder)
    }
    
    override func tearDown() {
        super.tearDown()
        cache = nil
        predicateBuilder = nil
        sut = nil
    }
    
    func testThatItProcessesFeedResponse() {
        // given
        let topic1 = Post(topicHandle: UUID().uuidString)
        let topic2 = Post(topicHandle: UUID().uuidString)
        let topic3 = Post(topicHandle: UUID().uuidString)

        var feed = FeedFetchResult()
        feed.posts = [topic1, topic2, topic3]
        
        let command = MockTopicCommand(topic: topic1)
        cache.fetchOutgoing_with_ReturnValue = [command]
        
        predicateBuilder.allTopicCommandsReturnValue = NSPredicate()
        
        // when
        sut.process(&feed)
        
        // then
        XCTAssertTrue(command.applyToFeedCalled)
        XCTAssertTrue(cache.fetchOutgoing_with_Called)
        XCTAssertTrue(predicateBuilder.allTopicCommandsCalled)
    }
}
