//
//  CreateAccountCreateAccountConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CreateAccountModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? CreateAccountViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: CreateAccountViewController) {

        let router = CreateAccountRouter()

        let presenter = CreateAccountPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = CreateAccountInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
