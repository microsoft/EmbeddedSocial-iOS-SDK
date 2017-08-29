//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct BlockedUsersConfigurator {
    
    let viewController: BlockedUsersViewController
    
    init() {
        viewController = StoryboardScene.BlockedUsers.instantiateBlockedUsersViewController()
        viewController.title = L10n.BlockedUsers.screenTitle
    }
    
    func configure(navigationController: UINavigationController?) {
        let presenter = BlockedUsersPresenter()
        presenter.view = viewController
        
        let api = BlockedUsersAPI(socialService: SocialService())
        presenter.usersListModule = UserListConfigurator()
            .configure(api: api, navigationController: navigationController, output: presenter)
        
        viewController.output = presenter
    }
}
