//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class UserListRouter: UserListRouterInput {
    weak var navController: UINavigationController?
    weak var myProfileOpener: MyProfileOpener?
    weak var userProfileModuleOutput: UserProfileModuleOutput?

    func openUserProfile(_ userID: String) {
        let configurator = UserProfileConfigurator()
        configurator.configure(userID: userID, navigationController: navController, output: userProfileModuleOutput)
        navController?.pushViewController(configurator.viewController, animated: true)
    }
    
    func openMyProfile() {
        myProfileOpener?.openMyProfile()
    }
}
