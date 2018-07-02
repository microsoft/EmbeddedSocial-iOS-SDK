//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct ReportConfigurator {
    let viewController: ReportViewController
    
    init() {
        viewController = StoryboardScene.Report.reportViewController.instantiate()
        viewController.title = L10n.Report.screenTitle
    }
    
    func configure(api: ReportAPI,
                   navigationController: UINavigationController?,
                   reportListTitle: String?,
                   myProfileHolder: UserHolder = SocialPlus.shared) {
        
        navigationController?.navigationBar.isTranslucent = false
        
        let strategy = CommonAuthorizedActionStrategy(loginParent: navigationController)
        let presenter = ReportPresenter(actionStrategy: strategy)
        presenter.view = viewController
        presenter.interactor = ReportInteractor(api: api)
        presenter.router = ReportRouter(navigationController: navigationController)
        
        viewController.output = presenter
        viewController.headerTitleLabel.text = reportListTitle
        viewController.theme = AppConfiguration.shared.theme
    }
}
