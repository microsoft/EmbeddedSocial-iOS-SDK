//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ActivityModuleConfigurator {
    
    private(set) var viewController: ActivityViewController!
    private(set) var module: ActivityModuleInput!

    func configure(navigationController: UINavigationController) {

        let router = ActivityRouter()
        router.navigationController = navigationController
        
        viewController = StoryboardScene.Activity.activityViewController.instantiate()

        let interactor = ActivityInteractor()
        
        let presenter = ActivityPresenter(interactor: interactor)
        presenter.view = viewController
        presenter.router = router
        
        module = presenter

        interactor.output = presenter
        interactor.service = SocialService()

        presenter.interactor = interactor
        
        viewController.output = presenter
        
        viewController.theme = SocialPlus.theme
    }

}
