//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CreatePostViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CreatePostViewController) {

        let router = CreatePostRouter()

        let presenter = CreatePostPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CreatePostInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
