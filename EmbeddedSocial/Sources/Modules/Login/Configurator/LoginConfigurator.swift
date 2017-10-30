//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class LoginConfigurator {
    
    let viewController: LoginViewController
    
    init() {
        viewController = StoryboardScene.Login.loginViewController.instantiate()
    }

    func configure(moduleOutput: LoginModuleOutput, source: SessionInfo.Source = .menu) {
        let router = LoginRouter()
        
        let presenter = LoginPresenter(source: source)
        presenter.view = viewController
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        
        let userService = UserService(imagesService: ImagesService(), errorHandler: UnauthorizedErrorHandler())
        presenter.interactor = LoginInteractor(authService: AuthService(apiProvider: AuthAPIProvider()),
                                               userService: userService,
                                               sessionService: SessionService())
        router.viewController = viewController
        router.createAccountOutput = presenter
        
        viewController.output = presenter
        viewController.title = L10n.Login.screenTitle
        viewController.theme = AppConfiguration.shared.theme
    }
}
