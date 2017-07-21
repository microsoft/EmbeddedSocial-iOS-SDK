//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostModuleConfigurator {

    func configure(viewController: CreatePostViewController, user: User) {

        let router = CreatePostRouter()

        let presenter = CreatePostPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.user = user

        let interactor = CreatePostInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
