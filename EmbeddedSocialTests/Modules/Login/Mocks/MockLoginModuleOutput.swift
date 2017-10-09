//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockLoginModuleOutput: LoginModuleOutput {
    private(set) var onSessionCreatedCount = 0
    private(set) var onSessionCreatedInputSessionInfo: SessionInfo?

    func onSessionCreated(with info: SessionInfo) {
        onSessionCreatedCount += 1
        onSessionCreatedInputSessionInfo = info
    }
}
