//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class ReportRouter: ReportRouterInput {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func openReportSuccess(onDone: (() -> Void)?) {
        let vc = StoryboardScene.Report.reportSubmittedViewController.instantiate()
        vc.title = L10n.Report.screenTitle
        vc.onDone = onDone
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
