//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct LinkedAccountsConfigurator {
    let viewController: LinkedAccountsViewController
    
    init() {
        viewController = StoryboardScene.LinkedAccounts.linkedAccountsViewController.instantiate()
        viewController.title = L10n.LinkedAccounts.screenTitle
    }
    
    func configure(sessionToken: String) {
        let presenter = LinkedAccountsPresenter()
        
        let usersService = UserService(imagesService: ImagesService())
        let authService = AuthService(apiProvider: AuthAPIProvider())
        presenter.interactor = LinkedAccountsInteractor(usersService: usersService,
                                                        authService: authService,
                                                        sessionToken: sessionToken)
        presenter.view = viewController
        
        viewController.output = presenter
        viewController.theme = SocialPlus.theme
    }
}
