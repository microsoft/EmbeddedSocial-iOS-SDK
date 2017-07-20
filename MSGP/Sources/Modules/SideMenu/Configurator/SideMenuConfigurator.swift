//
//  SideMenuSideMenuConfigurator.swift
//  MSGP-Framework
//
//  Created by igor.popov on 17/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class SideMenuModuleConfigurator {
    
    class func configure(viewController: SideMenuViewController,
                         configuration: SideMenuType,
                         socialMenuItemsProvider: SideMenuItemsProvider,
                         clientMenuItemsProvider: SideMenuItemsProvider?,
                         output: SideMenuModuleOutput) -> SideMenuModuleInput {

        let router = SideMenuRouter()
        router.output = output

        let presenter = SideMenuPresenter()
        presenter.view = viewController
        presenter.router = router
        
        let interactor = SideMenuInteractor()
        interactor.output = presenter
        interactor.clientMenuItemsProvider = clientMenuItemsProvider
        interactor.socialMenuItemsProvider = socialMenuItemsProvider

        presenter.interactor = interactor
        presenter.configation = configuration
        viewController.output = presenter
        
        return presenter
    }
}
