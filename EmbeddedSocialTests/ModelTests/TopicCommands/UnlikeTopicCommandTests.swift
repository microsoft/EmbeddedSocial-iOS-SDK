//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnlikeTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post.mock(seed: 1)
        topic.liked = false
        topic.totalLikes = 0
        let sut = UnlikeTopicCommand(topic: topic)
        
        // when
        sut.apply(to: &topic)
        
        // then
        XCTAssertFalse(topic.liked)
        XCTAssertEqual(topic.totalLikes, 0)
        
        // when
        topic.totalLikes = 5
        sut.apply(to: &topic)
        
        // then
        XCTAssertEqual(topic.totalLikes, 4)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let topic = Post.mock(seed: 1)
        let sut = UnlikeTopicCommand(topic: topic)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? LikeTopicCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.topic, inverseCommand.topic)
    }
}
