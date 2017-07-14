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
        viewController = StoryboardScene.CreateAccount.instantiateCreateAccountViewController()
    }

    func configure(user: SocialUser, moduleOutput: CreateAccountModuleOutput?) {
        let router = CreateAccountRouter()

        let presenter = CreateAccountPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = CreateAccountInteractor(user: user, authService: AuthService(apiProvider: AuthAPIProvider()))
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        viewController.title = "Create an account"
    }
}
