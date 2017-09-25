//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class PinTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post(topicHandle: UUID().uuidString)
        let sut = PinTopicCommand(topic: topic)
        
        // when
        sut.apply(to: &topic)
        
        // then
        XCTAssertTrue(topic.pinned)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let topic = Post(topicHandle: UUID().uuidString)
        let sut = PinTopicCommand(topic: topic)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? UnpinTopicCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.topic, inverseCommand.topic)
    }
}
