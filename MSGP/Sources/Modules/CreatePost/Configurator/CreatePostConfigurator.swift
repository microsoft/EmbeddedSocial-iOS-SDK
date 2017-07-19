//
//  CreatePostCreatePostConfigurator.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
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
