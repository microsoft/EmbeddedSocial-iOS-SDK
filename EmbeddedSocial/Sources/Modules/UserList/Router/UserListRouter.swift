//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UserListRouter: UserListRouterInput {
    weak var navController: UINavigationController?
    weak var myProfileOpener: MyProfileOpener?
    weak var loginPopupOpener: LoginPopupOpener?

    func openUserProfile(_ userID: String) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userID, navigationController: navController)
        navController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openMyProfile() {
        myProfileOpener?.openMyProfile()
    }
    
    func openLoginPopup() {
        loginPopupOpener?.openLoginPopup()
    }
}
