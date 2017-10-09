//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockAuthService: AuthServiceType {
    
    var loginCalled = false
    var loginInputValues: (provider: AuthProvider, viewController: UIViewController?)?
    var loginReturnValue: Result<SocialUser>!

    func login(with provider: AuthProvider,
               from viewController: UIViewController?,
               handler: @escaping (Result<SocialUser>) -> Void) {
        
        loginCalled = true
        loginInputValues = (provider, viewController)
        handler(loginReturnValue)
    }
}
