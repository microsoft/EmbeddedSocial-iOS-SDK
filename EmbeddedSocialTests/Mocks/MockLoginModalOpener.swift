//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockLoginModalOpener: LoginModalOpener {
    
    var openLoginCalled = false
    var openLoginInputParentViewController: UIViewController?
    
    func openLogin(parentViewController: UIViewController?) {
        openLoginCalled = true
        openLoginInputParentViewController = parentViewController
    }
}
