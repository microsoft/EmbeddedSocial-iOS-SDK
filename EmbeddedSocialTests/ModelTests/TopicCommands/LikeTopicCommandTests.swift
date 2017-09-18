//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class LikeTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post()
        topic.topicHandle = UUID().uuidString
        let sut = LikeTopicCommand(topicHandle: topic.topicHandle!)
        
        // when
        sut.apply(to: &topic)
        
        // then
        XCTAssertTrue(topic.liked)
        XCTAssertEqual(topic.totalLikes, 1)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        var topic = Post()
        topic.topicHandle = UUID().uuidString
        let sut = LikeTopicCommand(topicHandle: topic.topicHandle!)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnlikeTopicCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.topicHandle, inverseCommand.topicHandle)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        var topic = Post()
        topic.topicHandle = UUID().uuidString
        let sut = LikeTopicCommand(topicHandle: topic.topicHandle!)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "LikeTopicCommand-\(topic.topicHandle!)")
    }
}
