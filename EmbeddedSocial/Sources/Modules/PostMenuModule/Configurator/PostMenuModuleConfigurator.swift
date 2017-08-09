//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

class PostMenuModuleModuleConfigurator {

    private func configure(viewController: PostMenuModuleViewController) {

        let router = PostMenuModuleRouter()

        let presenter = PostMenuModulePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = PostMenuModuleInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
