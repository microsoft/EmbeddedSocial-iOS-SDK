//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class EditProfileConfigurator {
    
    let viewController: EditProfileViewController
    
    init() {
        viewController = StoryboardScene.EditProfile.instantiateEditProfileViewController()
    }

    func configure(user: User, moduleOutput: EditProfileModuleOutput?) {
        let presenter = EditProfilePresenter(user: user)
        presenter.view = viewController
        presenter.interactor = EditProfileInteractor(userService: UserService(imagesService: ImagesService()))
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
        viewController.title = "Edit profile"
        
        let editConfigurator = EmbeddedEditProfileConfigurator()
        presenter.editModuleInput = editConfigurator.configure(user: user, moduleOutput: presenter)
    }
}
