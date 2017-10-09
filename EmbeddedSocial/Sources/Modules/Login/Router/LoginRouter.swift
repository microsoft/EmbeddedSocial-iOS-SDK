//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class LoginRouter: LoginRouterInput {
    
    weak var viewController: UIViewController?
    weak var createAccountOutput: CreateAccountModuleOutput?
    
    func openCreateAccount(user: User) {
        let createAccount = CreateAccountConfigurator()
        createAccount.configure(user: user, moduleOutput: createAccountOutput)
        viewController?.navigationController?.pushViewController(createAccount.viewController, animated: true)
    }
    
    func dismiss() {
        viewController?.navigationController?.dismiss(animated: true)
    }
}
