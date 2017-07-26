//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockCreateAccountModuleOutput: CreateAccountModuleOutput {
    private(set) var onAccountCreatedCount = 0
    private(set) var lastOnAccountCreatedUser: User?
    private(set) var lastOnAccountSessionToken: String?
    
    func onAccountCreated(user: User, sessionToken: String) {
        onAccountCreatedCount += 1
        lastOnAccountCreatedUser = user
        lastOnAccountSessionToken = sessionToken
    }
}
