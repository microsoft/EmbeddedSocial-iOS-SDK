//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class TopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChangesToFeed() {
        // given
        let topic1 = Post.mock(seed: 0)
        let topic2 = Post.mock(seed: 1)
        let topic3 = Post.mock(seed: 2)

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
