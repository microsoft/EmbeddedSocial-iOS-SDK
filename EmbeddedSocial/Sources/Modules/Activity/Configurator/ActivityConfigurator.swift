//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ActivityModuleConfigurator {
    
    private(set) var viewController: ActivityViewController!
    private(set) var module: ActivityModuleInput!

    func configure() {

        let router = ActivityRouter()
        
        viewController = StoryboardScene.Activity.instantiateActivityViewController()

        let presenter = ActivityPresenter()
        presenter.view = viewController
        presenter.router = router
        
        module = presenter

        let interactor = ActivityInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
