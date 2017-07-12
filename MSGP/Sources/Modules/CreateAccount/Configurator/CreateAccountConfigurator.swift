//
//  CreateAccountConfigurator.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

class CreateAccountConfigurator {
    
    let viewController: CreateAccountViewController
    
    init() {
        viewController = Storyboard.createAccount.createAccountViewController()!
    }

    func configure(moduleOutput: CreateAccountModuleOutput?) {
        let router = CreateAccountRouter()

        let presenter = CreateAccountPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = CreateAccountInteractor(authService: AuthService())
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        viewController.title = "Create Account"
    }
}
