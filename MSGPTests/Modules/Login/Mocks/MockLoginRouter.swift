//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockLoginRouter: LoginRouterInput {
    private(set) var openCreateAccountCount = 0
    
    func openCreateAccount(user: SocialUser) {
        openCreateAccountCount += 1
    }
}
