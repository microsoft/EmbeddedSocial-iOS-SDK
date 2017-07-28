//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct UserProfileConfigurator {
    
    let viewController: UserProfileViewController
    
    init() {
        viewController = StoryboardScene.UserProfile.instantiateUserProfileViewController()
    }
    
    func configure(userID: String?, me: User) {
        let router = UserProfileRouter()
        router.viewController = viewController
        
        let presenter = UserProfilePresenter(userID: userID, me: me)
        presenter.router = router
        presenter.interactor = UserProfileInteractor(userService: UserService(), socialService: SocialService())
        presenter.view = viewController
        
        viewController.output = presenter
        
        viewController.title = "Profile"
    }
}
