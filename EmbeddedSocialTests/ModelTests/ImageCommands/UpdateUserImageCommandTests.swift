//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UpdateUserImageCommandTests: XCTestCase {
    
    func testThatItReturnsCorrectInverseCommand() {
        // given
        let photo = Photo()
        let sut = UpdateUserImageCommand(photo: photo, relatedHandle: UUID().uuidString)
        XCTAssertNil(sut.inverseCommand)
    }
}

