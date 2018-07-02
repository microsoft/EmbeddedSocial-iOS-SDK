//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockAuthorizedActionStrategy: AuthorizedActionStrategy {
    
    var executeOrPromptLoginCalled = false
    func executeOrPromptLogin(_ action: () -> Void) {
        executeOrPromptLoginCalled = true
        action()
    }
}
