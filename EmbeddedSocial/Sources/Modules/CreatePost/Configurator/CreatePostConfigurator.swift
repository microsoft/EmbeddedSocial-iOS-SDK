//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CreatePostModuleConfigurator {

    func configure(viewController: CreatePostViewController,
                   user: User,
                   moduleOutput: CreatePostModuleOutput? = nil,
                   cache: CacheType = SocialPlus.shared.cache) {

        let router = CreatePostRouter()

        let presenter = CreatePostPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.user = user
        presenter.moduleOutput = moduleOutput

        let interactor = CreatePostInteractor()
        interactor.output = presenter
        let topicService = TopicService(cache: cache)
        interactor.topicService = topicService

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
