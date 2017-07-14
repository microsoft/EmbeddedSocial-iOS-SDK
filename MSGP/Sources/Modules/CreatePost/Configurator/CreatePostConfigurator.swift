//
//  CreatePostCreatePostConfigurator.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
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
