//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SideMenuModuleConfigurator {
    
    var viewController: SideMenuViewController!
    var moduleInput: SideMenuModuleInput!
    var router: SideMenuRouter!
    
    func configure(coordinator: CrossModuleCoordinator,
                   configuration: SideMenuType,
                   socialMenuItemsProvider: SideMenuItemsProvider,
                   clientMenuItemsProvider: SideMenuItemsProvider?) {
        
        viewController = StoryboardScene.MenuStack.instantiateSideMenuViewController()
        
        router = SideMenuRouter()
        router.coordinator = coordinator
        
        let presenter = SideMenuPresenter()
        presenter.view = viewController
        presenter.router = router
        
        let interactor = SideMenuInteractor()
        interactor.output = presenter
        interactor.clientMenuItemsProvider = clientMenuItemsProvider
        interactor.socialMenuItemsProvider = socialMenuItemsProvider
        
        presenter.interactor = interactor
        presenter.configuration = configuration
        viewController.output = presenter
        
        moduleInput = presenter
    }
}
