//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UpdateTopicCommandTests: XCTestCase {
    
    func testThatItCorrectlyAppliesChanges() {
        // given
        var topic = Post.mock()
        
        var topic2 = Post.mock()
        topic2.text = "new text"
        topic2.title = "new title"
        
        let command = UpdateTopicCommand(topic: topic2)
        
        // when
        command.apply(to: &topic)
        
        // then
        XCTAssertEqual(topic.text, "new text")
        XCTAssertEqual(topic.title,"new title")
    }
    
}
