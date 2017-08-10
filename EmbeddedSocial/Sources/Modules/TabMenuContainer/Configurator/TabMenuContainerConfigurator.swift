//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class TabMenuContainerModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? TabMenuContainerViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: TabMenuContainerViewController) {

        let router = TabMenuContainerRouter()

        let presenter = TabMenuContainerPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = TabMenuContainerInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
