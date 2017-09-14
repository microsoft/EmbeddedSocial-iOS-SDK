//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import XCTest
@testable import EmbeddedSocial

class UserCommandTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testThatItCreatesCommandFromJSON() {
        // given
        let user = User()
        let jsons: [[String: Any]] = UserCommand.allCommandTypes.map { type -> [String: Any] in
            return [
                "user": user,
                "type": String(describing: type(of: type))
            ]
        }
        
        // when
        let commands = jsons.flatMap(UserCommand.command)
        
        // then
        for (index, command) in commands.enumerated() {
            validateCommand(command: command, hasType: UserCommand.allCommandTypes[index], hasUser: user)
        }
    }
    
    private func validateCommand<T: UserCommand>(command: UserCommand, hasType: T.Type, hasUser user: User) {
        XCTAssertTrue(command is T)
        XCTAssertEqual(command.user, user)
    }
    
    func testThatItReturnsCorrectCombinedHandle() {
        // given
        let user = User()
        let sut = UserCommand(user: user)
        
        // when
        let handle = sut.combinedHandle
        
        // then
        XCTAssertEqual(handle, "UserCommand-\(user.uid)")
    }
}





