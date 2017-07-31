//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockLoginModuleOutput: LoginModuleOutput {
    private(set) var onSessionCreatedCount = 0
    
    func onSessionCreated(user: User, sessionToken: String) {
        onSessionCreatedCount += 1
    }
}
