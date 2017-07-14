//
//  MenuMenuConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 10/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? MenuViewController {
            configure(viewController: viewController)
        }
    }


    private func configure(viewController: MenuViewController) {

        let router = MenuRouter()

        let presenter = MenuPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = MenuInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
