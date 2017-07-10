//
//  WelcomeWelcomeConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 07/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class WelcomeModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? WelcomeViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: WelcomeViewController) {

        let router = WelcomeRouter()

        let presenter = WelcomePresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = WelcomeInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
