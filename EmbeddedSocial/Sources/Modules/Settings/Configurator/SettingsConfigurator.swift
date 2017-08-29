//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SettingsConfigurator {
    let viewController: SettingsViewController
    
    init() {
        viewController = StoryboardScene.Settings.instantiateSettingsViewController()
        viewController.title = L10n.Settings.screenTitle
    }
    
    func configure(navigationController: UINavigationController?) {
        let router = SettingsRouter(navigationController: navigationController)
        
        let presenter = SettingsPresenter()
        presenter.router = router
        presenter.view = viewController
        
        viewController.output = presenter
    }
}
