//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockFacebookAPI: FacebookAPI {
    var hasGrantedFriendsListPermission = false
    
    //MARK: - login
    
    var loginCalled = false
    var loginInputViewController: UIViewController?
    var loginResult: Result<SocialUser>!
    
    func login(from viewController: UIViewController?, handler: @escaping (Result<SocialUser>) -> Void) {
        loginCalled = true
        loginInputViewController = viewController
        handler(loginResult)
    }

}
