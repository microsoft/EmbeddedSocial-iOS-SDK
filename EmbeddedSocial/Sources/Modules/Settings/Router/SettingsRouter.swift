//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit
import SafariServices

final class SettingsRouter: SettingsRouterInput {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func openBlockedList() {
        let conf = BlockedUsersConfigurator()
        conf.configure(navigationController: navigationController)
        navigationController?.pushViewController(conf.viewController, animated: true)
    }
    
    func openLinkedAccounts(sessionToken: String) {
        let conf = LinkedAccountsConfigurator()
        conf.configure(sessionToken: sessionToken)
        navigationController?.pushViewController(conf.viewController, animated: true)
    }
    
    func openLink(type: SettingsLinkRouter) {
        let url: URL!
        switch type {
        case .privacyPolicy:
            url = Constants.Settings.privacyPolicyURL
        case .termsAndConditions:
            url = Constants.Settings.termsAndConditionsURL
        }
        
        let vc = SFSafariViewController(url: url)
        navigationController?.present(vc, animated: true)
    }
}
