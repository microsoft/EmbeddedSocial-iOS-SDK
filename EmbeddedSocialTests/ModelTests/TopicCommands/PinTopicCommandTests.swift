//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PinTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post()
        topic.topicHandle = UUID().uuidString
        let sut = PinTopicCommand(topicHandle: topic.topicHandle!)
        
        // when
        sut.apply(to: &topic)
        
        // then
        XCTAssertTrue(topic.pinned)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        var topic = Post()
        topic.topicHandle = UUID().uuidString
        let sut = PinTopicCommand(topicHandle: topic.topicHandle!)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnpinTopicCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.topicHandle, inverseCommand.topicHandle)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        var topic = Post()
        topic.topicHandle = UUID().uuidString
        let sut = PinTopicCommand(topicHandle: topic.topicHandle!)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "PinTopicCommand-\(topic.topicHandle!)")
    }
}
