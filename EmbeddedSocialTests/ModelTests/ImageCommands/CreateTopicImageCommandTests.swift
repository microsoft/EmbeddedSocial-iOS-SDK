//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class CreateTopicImageCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let photo = Photo()
        let sut = CreateTopicImageCommand(photo: photo, relatedHandle: UUID().uuidString)
        XCTAssertNil(sut.inverseCommand)
    }
}

