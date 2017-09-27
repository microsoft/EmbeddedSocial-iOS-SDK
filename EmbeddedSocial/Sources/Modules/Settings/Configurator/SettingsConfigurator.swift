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
    
    func configure(myProfileHolder: UserHolder = SocialPlus.shared, logoutController: LogoutController = SocialPlus.shared, navigationController: UINavigationController?) {
        let router = SettingsRouter(navigationController: navigationController)
        
        let presenter = SettingsPresenter(myProfileHolder: myProfileHolder)
        presenter.router = router
        presenter.view = viewController
        let userService = UserService(imagesService: ImagesService())
        presenter.interactor = SettingsInteractor(userService: userService, logoutController: logoutController)
        viewController.output = presenter
    }
}
