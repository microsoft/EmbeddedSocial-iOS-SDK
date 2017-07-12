//
//  MenuStackMenuStackConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class MenuStackModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? MenuStackViewController {
            configure(viewController: viewController)
        }
    }
    
    func configure(viewController: MenuStackViewController, format: NavigationStackFormat) {
        
        let router = MenuStackRouter()
        
        let presenter = MenuStackPresenter()
        presenter.view = viewController
        presenter.router = router
        
        let interactor = MenuStackInteractor()
        interactor.output = presenter
        
        presenter.interactor = interactor
        viewController.output = presenter
        
    }

    private func configure(viewController: MenuStackViewController) {

        let router = MenuStackRouter()

        let presenter = MenuStackPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = MenuStackInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
