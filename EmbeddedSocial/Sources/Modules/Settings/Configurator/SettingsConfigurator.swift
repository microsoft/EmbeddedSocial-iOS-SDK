//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct SettingsConfigurator {
    let viewController: SettingsViewController
    
    init() {
        viewController = StoryboardScene.Settings.settingsViewController.instantiate()
        viewController.title = L10n.Settings.screenTitle
        viewController.theme = AppConfiguration.shared.theme
    }
    
    func configure(myProfileHolder: UserHolder = SocialPlus.shared,
                   logoutController: LogoutController = SocialPlus.shared,
                   navigationController: UINavigationController?) {
        
        let presenter = SettingsPresenter(myProfileHolder: myProfileHolder)
        presenter.router = SettingsRouter(navigationController: navigationController)
        presenter.view = viewController
        
        let storage = SearchHistoryStorage(userID: myProfileHolder.me?.uid ?? "")
        presenter.interactor = SettingsInteractor(userService: UserService(imagesService: ImagesService()),
                                                  logoutController: logoutController,
                                                  searchHistoryStorage: storage)
        
        viewController.output = presenter
    }
}
