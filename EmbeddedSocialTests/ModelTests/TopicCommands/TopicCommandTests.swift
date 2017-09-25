//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class TopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChangesToFeed() {
        // given
        let topic1 = Post(topicHandle: UUID().uuidString)
        let topic2 = Post(topicHandle: UUID().uuidString)
        let topic3 = Post(topicHandle: UUID().uuidString)

        var feed = FeedFetchResult()
        feed.posts = [topic1, topic2, topic3]
        
        let sut = MockTopicCommand(topic: topic1)
        
        // when
        sut.apply(to: &feed)
        
        // then
        XCTAssertTrue(sut.applyToTopicCalled)
        XCTAssertEqual(topic1, sut.applyToTopicInputTopic)
    }
}
