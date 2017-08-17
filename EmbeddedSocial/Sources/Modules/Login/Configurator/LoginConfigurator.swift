//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class LoginConfigurator {
    
    let viewController: LoginViewController
    
    init() {
        viewController = StoryboardScene.Login.instantiateLoginViewController()
    }

    func configure(moduleOutput: LoginModuleOutput) {
        let router = LoginRouter()
        
        let presenter = LoginPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        presenter.interactor = LoginInteractor(authService: AuthService(apiProvider: AuthAPIProvider()),
                                               userService: UserService(imagesService: ImagesService()),
                                               sessionService: SessionService())
        router.viewController = viewController
        router.createAccountOutput = presenter
        
        viewController.output = presenter
        
        viewController.title = L10n.Login.screenTitle
    }
}
