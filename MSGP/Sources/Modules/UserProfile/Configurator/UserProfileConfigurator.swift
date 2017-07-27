//
//  UserProfileConfigurator.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/27/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
