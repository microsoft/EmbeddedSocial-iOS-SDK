//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UnpinTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post.mock(seed: 0)
        let sut = UnpinTopicCommand(topic: topic)
        
        // when
        topic.pinned = true
        sut.apply(to: &topic)
        
        // then
        XCTAssertFalse(topic.pinned)
    }
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let topic = Post.mock(seed: 0)
        let sut = UnpinTopicCommand(topic: topic)
        
        // when
        
        // then
        guard let inverseCommand = sut.inverseCommand as? PinTopicCommand else {
            XCTFail("Must return inverse command")
            return
        }
        XCTAssertEqual(sut.topic, inverseCommand.topic)
    }
}
