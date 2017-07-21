//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
