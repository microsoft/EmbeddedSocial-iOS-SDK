//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum DetailedActivityState {
    case comment
    case reply
}

class DetailedActivityModuleConfigurator {

    let viewController = StoryboardScene.DetailedActivity.initialViewController() as! DetailedActivityViewController
    
    func configure(state: DetailedActivityState, commentHandle: String? = nil, replyHandle: String? = nil) {

        let router = DetailedActivityRouter()

        let presenter = DetailedActivityPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.state = state

        let interactor = DetailedActivityInteractor()
        interactor.output = presenter
        interactor.commentHandle = commentHandle
        interactor.replyHandle = replyHandle

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
