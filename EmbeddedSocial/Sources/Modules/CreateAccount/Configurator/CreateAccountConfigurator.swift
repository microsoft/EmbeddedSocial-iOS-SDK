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
        let imagesService = ImagesService()
        let userService = UserService(imagesService: ImagesService())
        let authService = AuthService(apiProvider: AuthAPIProvider())
        let interactor = CreateAccountInteractor(userService: userService, imagesService: imagesService, authService: authService)
        interactor.loginViewController = viewController
        
        let presenter = CreateAccountPresenter(user: user)
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.moduleOutput = moduleOutput
        
        let editConfigurator = EmbeddedEditProfileConfigurator()
        presenter.editModuleInput = editConfigurator.configure(user: user, moduleOutput: presenter)
        
        viewController.output = presenter
        viewController.title = L10n.CreateAccount.screenTitle
    }
}
