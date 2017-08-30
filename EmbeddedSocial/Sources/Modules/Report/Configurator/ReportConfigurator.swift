//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportConfigurator {
    let viewController: ReportViewController
    
    init() {
        viewController = StoryboardScene.Report.instantiateReportViewController()
        viewController.title = L10n.Report.screenTitle
    }
    
    func configure(userID: String, navigationController: UINavigationController?) {
        navigationController?.navigationBar.isTranslucent = false
        
        let presenter = ReportPresenter(userID: userID)
        presenter.view = viewController
        presenter.interactor = ReportInteractor(reportingService: ReportingService())
        presenter.router = ReportRouter(navigationController: navigationController)
        
        viewController.output = presenter
    }
}
