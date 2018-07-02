//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockUserCommand: UserCommand {
    
    private(set) var applyCalled = false
    private(set) var applyInputUser: User?
    
    override func apply(to user: inout User) {
        applyCalled = true
        applyInputUser = user
    }
}
