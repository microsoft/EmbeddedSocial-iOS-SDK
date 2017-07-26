//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import MSGP

class CreateAccountValidatorTests: XCTestCase {
    typealias Options = CreateAccountValidator.Options
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFirstNameValidation() {
        // given
        let validOptions = Options(firstName: UUID().uuidString, lastName: UUID().uuidString, bio: UUID().uuidString, photo: nil)
        let invalidOptions1 = Options(firstName: nil, lastName: UUID().uuidString, bio: UUID().uuidString, photo: nil)
        let invalidOptions2 = Options(firstName: "", lastName: UUID().uuidString, bio: UUID().uuidString, photo: nil)
        let invalidOptions3 = Options(firstName: " ", lastName: UUID().uuidString, bio: UUID().uuidString, photo: nil)

        // when
        
        // then
        XCTAssertTrue(CreateAccountValidator.validate(validOptions))
        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions1))
        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions2))
        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions3))
    }
    
    func testLastNameValidation() {
        // given
        let validOptions = Options(firstName: UUID().uuidString, lastName: UUID().uuidString, bio: UUID().uuidString, photo: nil)
        let invalidOptions1 = Options(firstName: UUID().uuidString, lastName: nil, bio: UUID().uuidString, photo: nil)
        let invalidOptions2 = Options(firstName: UUID().uuidString, lastName: "", bio: UUID().uuidString, photo: nil)
        let invalidOptions3 = Options(firstName: UUID().uuidString, lastName: " ", bio: UUID().uuidString, photo: nil)

        // when
        
        // then
        XCTAssertTrue(CreateAccountValidator.validate(validOptions))
        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions1))
        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions2))
        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions3))
    }
    
    func testBioValidation() {
        // given
        let pad = "A"
        
        let validOptions1 = Options(firstName: UUID().uuidString, lastName: UUID().uuidString, bio: UUID().uuidString, photo: nil)
        let validOptions2 = Options(firstName: UUID().uuidString, lastName: UUID().uuidString, bio: nil, photo: nil)
        let validOptions3 = Options(firstName: UUID().uuidString, lastName: UUID().uuidString,
                                    bio: "".padding(toLength: 500, withPad: pad, startingAt: 0), photo: nil)

        let invalidOptions1 = Options(firstName: UUID().uuidString, lastName: UUID().uuidString,
                                      bio: "".padding(toLength: 501, withPad: pad, startingAt: 0), photo: nil)
        
        // when
        
        // then
        XCTAssertTrue(CreateAccountValidator.validate(validOptions1))
        XCTAssertTrue(CreateAccountValidator.validate(validOptions2))
        XCTAssertTrue(CreateAccountValidator.validate(validOptions3))

        XCTAssertFalse(CreateAccountValidator.validate(invalidOptions1))
    }
    
    func testImageValidation() {
        // given
        let validOptions1 = Options(firstName: UUID().uuidString, lastName: UUID().uuidString, bio: nil, photo: nil)
        let validOptions2 = Options(firstName: UUID().uuidString, lastName: UUID().uuidString,
                                    bio: nil, photo: UIImage(color: .yellow, size: CGSize(width: 8.0, height: 8.0)))
        
        // when
        
        // then
        XCTAssertTrue(CreateAccountValidator.validate(validOptions1))
        XCTAssertTrue(CreateAccountValidator.validate(validOptions2))
    }
}
