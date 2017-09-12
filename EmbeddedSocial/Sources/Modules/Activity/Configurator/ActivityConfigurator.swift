//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ActivityModuleConfigurator {


    private func configure(viewController: ActivityViewController) {

        let router = ActivityRouter()

        let presenter = ActivityPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ActivityInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
