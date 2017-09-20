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
}

