//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct FollowRequestsConfigurator {
    
    let viewController: FollowRequestsViewController
    
    init() {
        viewController = StoryboardScene.FollowRequests.instantiateFollowRequestsViewController()
        viewController.title = L10n.FollowRequests.screenTitle.uppercased()
    }
    
    func configure(navigationController: UINavigationController?) {
        let presenter = FollowRequestsPresenter()
        presenter.router = FollowRequestsRouter(navigationController: navigationController)
        presenter.interactor = FollowRequestsInteractor()
        presenter.view = viewController
        
        viewController.output = presenter
    }
}
