//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateTopicCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let topic = Post(topicHandle: UUID().uuidString)
        let sut = CreateTopicCommand(topic: topic)
        XCTAssertNil(sut.inverseCommand)
    }
    
    func testThatItAppliedChangesToFeed() {
        // given
        var feed = FeedFetchResult()
        feed.posts = [Post(topicHandle: UUID().uuidString), Post(topicHandle: UUID().uuidString)]
        
        let sut = CreateTopicCommand(topic: Post(topicHandle: UUID().uuidString))
        
        // when
        sut.apply(to: &feed)
        
        // then
        XCTAssertEqual(feed.posts.count, 3)
        XCTAssertEqual(feed.posts.first, sut.topic)
    }
}

