//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
@testable import MSGP

final class MockCreateAccountViewPlainObject: CreateAccountViewInput {
    private(set) var setUserCount = 0
    private(set) var lastSetUser: SocialUser?
    
    func setUser(_ user: SocialUser) {
        setUserCount += 1
        lastSetUser = user
    }
    
    func setupInitialState(with user: SocialUser) { }
    
    func showError(_ error: Error) { }
    
    func setCreateAccountButtonEnabled(_ isEnabled: Bool) { }
    
    func setIsLoading(_ isLoading: Bool) { }
}
