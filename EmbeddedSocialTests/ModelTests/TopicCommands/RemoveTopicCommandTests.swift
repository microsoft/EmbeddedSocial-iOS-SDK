//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class RemoveTopicCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let topic = Post.mock()
        let sut = RemoveTopicCommand(topic: topic)
        XCTAssertNil(sut.inverseCommand)
    }
    
    func testThatItAppliedChangesToFeed() {
        // given
        var feed = FeedFetchResult()
        feed.posts = [Post.mock(seed: 0), Post.mock(seed: 1), Post.mock(seed: 2)]
        
        let sut = RemoveTopicCommand(topic: Post.mock(seed: 1))
        
        // when
        sut.apply(to: &feed)
        
        // then
        XCTAssertEqual(feed.posts.count, 2)
        XCTAssertFalse(feed.posts.contains(Post.mock(seed: 1)))
    }
}

