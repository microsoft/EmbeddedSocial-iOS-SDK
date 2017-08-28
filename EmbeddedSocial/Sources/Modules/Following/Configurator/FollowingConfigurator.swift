//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class FollowingConfigurator {
    let viewController: FollowingViewController
    
    init() {
        viewController = StoryboardScene.Following.instantiateFollowingViewController()
        viewController.title = L10n.Followers.screenTitle
    }
    
    func configure(api: UsersListAPI,
                   navigationController: UINavigationController?,
                   moduleOutput: FollowingModuleOutput? = nil) {
        
        let presenter = FollowingPresenter()

        let listInput = UserListConfigurator().configure(api: api, navigationController: navigationController, output: presenter)
        
        presenter.view = viewController
        presenter.usersList = listInput
        presenter.moduleOutput = moduleOutput

        viewController.output = presenter
    }
}
