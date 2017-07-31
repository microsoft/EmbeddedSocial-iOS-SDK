//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockSessionService: SessionServiceType {
    private(set) var makeNewSessionCount = 0
    private(set) var requestTokenCount = 0

    func makeNewSession(with credentials: CredentialsList, userUID: String, completion: @escaping (Result<String>) -> Void) {
        makeNewSessionCount += 1
    }
    
    func requestToken(authProvider: AuthProvider, completion: @escaping (Result<String>) -> Void) {
        requestTokenCount += 1
    }
}

