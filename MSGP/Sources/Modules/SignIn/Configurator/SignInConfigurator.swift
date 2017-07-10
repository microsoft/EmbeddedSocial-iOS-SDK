//
//  SignInSignInConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class SignInModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? SignInViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: SignInViewController) {

        let router = SignInRouter()

        let presenter = SignInPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = SignInInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
