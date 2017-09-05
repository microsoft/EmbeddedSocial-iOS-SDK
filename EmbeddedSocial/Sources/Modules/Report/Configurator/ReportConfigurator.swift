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
    
    func configure(api: ReportAPI,
                   navigationController: UINavigationController?,
                   isAnonymous: Bool = SocialPlus.shared.me == nil,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator) {
        
        navigationController?.navigationBar.isTranslucent = false
        
        let presenter = ReportPresenter(isAnonymous: isAnonymous)
        presenter.view = viewController
        presenter.interactor = ReportInteractor(api: api)
        presenter.router = ReportRouter(navigationController: navigationController, loginOpener: loginOpener)
        
        viewController.output = presenter
    }
}
