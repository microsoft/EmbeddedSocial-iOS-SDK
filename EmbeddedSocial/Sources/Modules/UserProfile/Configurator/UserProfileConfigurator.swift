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
    
    func configure(userID: String? = nil, myProfileHolder: UserHolder = SocialPlus.shared) {
        let router = UserProfileRouter()
        router.viewController = viewController
        
        let userService = UserService(imagesService: ImagesService())
        let presenter = UserProfilePresenter(userID: userID, myProfileHolder: myProfileHolder)
        presenter.router = router
        presenter.interactor = UserProfileInteractor(userService: userService, socialService: SocialService())
        presenter.view = viewController
        
        router.followersModuleOutput = presenter
        router.followingModuleOutput = presenter
        router.createPostModuleOutput = presenter
        router.editProfileModuleOutput = presenter
        
        viewController.output = presenter
        
        viewController.title = "Profile"
        
        let feedConfigurator = FeedModuleConfigurator(cache: SocialPlus.shared.cache) // TODO: inject cache
        feedConfigurator.configure(moduleOutput: presenter)

        presenter.feedViewController = feedConfigurator.viewController
        presenter.feedModuleInput = feedConfigurator.moduleInput
    }
}
