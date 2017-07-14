//
//  TabMenuContainerTabMenuContainerConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class TabMenuContainerModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? TabMenuContainerViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: TabMenuContainerViewController) {

        let router = TabMenuContainerRouter()

        let presenter = TabMenuContainerPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = TabMenuContainerInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
