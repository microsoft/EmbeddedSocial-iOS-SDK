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

    func configure(user: User, moduleOutput: CreateAccountModuleOutput?) {
        let presenter = CreateAccountPresenter(user: user)
        presenter.view = viewController
        presenter.interactor = CreateAccountInteractor(userService: UserService(imagesService: ImagesService()))
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        viewController.title = "Create an account"
        
        let editConfigurator = EmbeddedEditProfileConfigurator()
        presenter.editModuleInput = editConfigurator.configure(user: user, moduleOutput: presenter)
    }
}
