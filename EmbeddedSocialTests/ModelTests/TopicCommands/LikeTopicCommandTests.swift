//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post.mock(seed: 0)
        let sut = LikeTopicCommand(topic: topic)
        
        // when
        sut.apply(to: &topic)
        
        // then
        XCTAssertTrue(topic.liked)
        XCTAssertEqual(topic.totalLikes, 1)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let topic = Post.mock(seed: 0)
        let sut = LikeTopicCommand(topic: topic)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnlikeTopicCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.topic, inverseCommand.topic)
    }
}
