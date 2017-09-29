//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct LinkedAccountsConfigurator {
    let viewController: LinkedAccountsViewController
    
    init() {
        viewController = StoryboardScene.LinkedAccounts.linkedAccountsViewController.instantiate()
    }
    
    func configure() {
        let presenter = LinkedAccountsPresenter()
        presenter.interactor = LinkedAccountsInteractor(usersService: UserService(imagesService: ImagesService()))
        presenter.view = viewController
        
        viewController.output = presenter
    }
}
