//
//  LoginLoginRouter.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class LoginRouter: LoginRouterInput {
    
    weak var viewController: UIViewController?
    weak var createAccountModuleOutput: CreateAccountModuleOutput?
    
    func openCreateAccount() {
        let createAccount = CreateAccountConfigurator()
        createAccount.configure(moduleOutput: createAccountModuleOutput)
        viewController?.navigationController?.pushViewController(createAccount.viewController, animated: true)
    }
}
