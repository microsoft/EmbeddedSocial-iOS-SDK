//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockLoginRouter: LoginRouterInput {
    private(set) var openCreateAccountCount = 0
    
    func openCreateAccount(user: User) {
        openCreateAccountCount += 1
    }
}
