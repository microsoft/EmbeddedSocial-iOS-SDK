//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreateAccountConfigurator {
    
    let viewController: CreateAccountViewController
    
    init() {
        viewController = StoryboardScene.CreateAccount.instantiateCreateAccountViewController()
    }

    func configure(user: SocialUser, moduleOutput: CreateAccountModuleOutput?) {
        let presenter = CreateAccountPresenter(user: user)
        presenter.view = viewController
        presenter.router = CreateAccountRouter()
        presenter.interactor = CreateAccountInteractor(userService: UserService())
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        viewController.dataManager = CreateAccountDataDisplayManager()
        viewController.title = "Create an account"
    }
}
