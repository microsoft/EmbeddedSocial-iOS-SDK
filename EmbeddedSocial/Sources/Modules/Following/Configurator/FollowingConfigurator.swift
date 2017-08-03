//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class FollowingConfigurator {
    let viewController: FollowingViewController
    
    init() {
        viewController = StoryboardScene.Following.instantiateFollowingViewController()
        viewController.title = "Following"
    }
    
    func configure(api: UsersListAPI) {
        let presenter = FollowingPresenter()

        let listInput = UserListConfigurator().configure(api: api, output: presenter)
        
        presenter.view = viewController
        presenter.usersList = listInput
        
        viewController.output = presenter
    }
}
