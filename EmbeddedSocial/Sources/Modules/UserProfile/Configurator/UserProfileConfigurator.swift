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
    
    func configure(userID: String? = nil,
                   myProfileHolder: UserHolder = SocialPlus.shared,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator,
                   navigationController: UINavigationController?,
                   output: UserProfileModuleOutput? = nil) {
        
        let router = UserProfileRouter()
        router.viewController = viewController
        
        let userService = UserService(imagesService: ImagesService())
        let presenter = UserProfilePresenter(userID: userID, myProfileHolder: myProfileHolder)
        presenter.router = router
        presenter.interactor = UserProfileInteractor(userService: userService, socialService: SocialService())
        presenter.view = viewController
        presenter.moduleOutput = output
        
        router.followersModuleOutput = presenter
        router.followingModuleOutput = presenter
        router.createPostModuleOutput = presenter
        router.editProfileModuleOutput = presenter
        router.loginOpener = loginOpener
        router.followRequestsModuleOutput = presenter
        
        viewController.output = presenter
        
        viewController.title = L10n.UserProfile.screenTitle
        
        let feedConfigurator = FeedModuleConfigurator(cache: SocialPlus.shared.cache)
        feedConfigurator.configure(navigationController: navigationController, moduleOutput: presenter)

        presenter.feedViewController = feedConfigurator.viewController
        presenter.feedModuleInput = feedConfigurator.moduleInput
    }
}
