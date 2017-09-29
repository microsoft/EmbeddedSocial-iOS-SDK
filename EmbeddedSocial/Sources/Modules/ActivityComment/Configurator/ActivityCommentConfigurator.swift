//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class ActivityCommentModuleConfigurator {


    private func configure(viewController: ActivityCommentViewController) {

        let router = ActivityCommentRouter()

        let presenter = ActivityCommentPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = ActivityCommentInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
