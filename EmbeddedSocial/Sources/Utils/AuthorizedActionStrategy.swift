//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AuthorizedActionStrategy {
    func executeOrPromptLogin(_ action: () -> Void)
}

class CommonAuthorizedActionStrategy: AuthorizedActionStrategy {
    private let myProfileHolder: UserHolder
    weak private(set) var loginParent: UIViewController?
    private let loginOpener: LoginModalOpener

    init(myProfileHolder: UserHolder = SocialPlus.shared,
         loginParent: UIViewController?,
         loginOpener: LoginModalOpener = SocialPlus.shared.coordinator) {
        
        self.myProfileHolder = myProfileHolder
        self.loginParent = loginParent
        self.loginOpener = loginOpener
    }
    
    func executeOrPromptLogin(_ action: () -> Void) {
        if myProfileHolder.me != nil {
            action()
        } else {
            loginOpener.openLogin(parentViewController: loginParent)
        }
    }
}
