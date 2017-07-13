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
        viewController =  CreateAccountViewController()
    }

    func configure(user: User, moduleOutput: CreateAccountModuleOutput?) {
        let router = CreateAccountRouter()

        let presenter = CreateAccountPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = CreateAccountInteractor(authService: AuthService(apiProvider: AuthAPIProvider()))
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        viewController.title = "Create an account"
    }
}
