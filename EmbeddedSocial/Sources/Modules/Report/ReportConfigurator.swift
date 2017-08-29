//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct ReportConfigurator {
    let viewController: ReportViewController
    
    init() {
        viewController = StoryboardScene.Report.instantiateReportViewController()
    }
    
    func configure(userID: String, fullName: String) {
        let presenter = ReportPresenter(userID: userID)
        presenter.view = viewController
        presenter.interactor = ReportInteractor(reportingService: ReportingService())
        
        viewController.output = presenter
        viewController.title = L10n.Report.screenTitle(fullName)
    }
}
