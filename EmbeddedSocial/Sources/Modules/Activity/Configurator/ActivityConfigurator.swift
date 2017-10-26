//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ActivityModuleConfigurator {
    
    private(set) var viewController: ActivityViewController!
    private(set) var module: ActivityModuleInput!

    func configure(navigationController: UINavigationController,
                   notificationsUpdater: NotificationsUpdater,
                   userHolder: UserHolder = SocialPlus.shared) {

        let router = ActivityRouter()
        router.navigationController = navigationController
        
        viewController = StoryboardScene.Activity.activityViewController.instantiate()

        let interactor = ActivityInteractor()
        interactor.notificationsUpdater = notificationsUpdater
        
        let presenter = ActivityPresenter(interactor: interactor, userProvider: userHolder)
        presenter.view = viewController
        presenter.router = router
        presenter.theme = AppConfiguration.shared.theme
        
        module = presenter

        interactor.output = presenter
        interactor.service = SocialService()

        presenter.interactor = interactor
        
        viewController.output = presenter
        
        viewController.theme = AppConfiguration.shared.theme
    }

}
