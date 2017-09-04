//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportRouter: ReportRouterInput {
    weak var navigationController: UINavigationController?
    weak var loginPopupOpener: LoginPopupOpener?
    
    init(navigationController: UINavigationController?, loginPopupOpener: LoginPopupOpener?) {
        self.navigationController = navigationController
        self.loginPopupOpener = loginPopupOpener
    }
    
    func openReportSuccess(onDone: (() -> Void)?) {
        let vc = StoryboardScene.Report.instantiateReportSubmittedViewController()
        vc.title = L10n.Report.screenTitle
        vc.onDone = onDone
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func close() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func openLoginPopup() {
        loginPopupOpener?.openLoginPopup()
    }
}
