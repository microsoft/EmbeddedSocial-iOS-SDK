//
//  LoginConfigurator.swift
//  MSGP
//
//  Created by ls on 06/07/2017.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import UIKit

final class LoginConfigurator {
    
    let viewController: LoginViewController
    
    init() {
        self.viewController = Storyboard.login.loginViewController()!
    }

    func configure(moduleOutput: LoginModuleOutput) {
        let router = LoginRouter()
        
        let presenter = LoginPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        presenter.interactor = LoginInteractor(authService: AuthService(apiProvider: AuthAPIProvider()))
        
        router.viewController = viewController
        router.createAccountOutput = presenter
        
        viewController.output = presenter
        
        viewController.title = "Sign in"
    }
}
