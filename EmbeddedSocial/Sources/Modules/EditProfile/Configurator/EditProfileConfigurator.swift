//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct EditProfileConfigurator {
    let view: EditProfileView
    
    init() {
        view = EditProfileView()
    }
    
    func configure(user: User, moduleOutput: EditProfileModuleOutput?) -> EditProfileModuleInput {
        let router = EditProfileRouter()
        
        let presenter = EditProfilePresenter(user: user)
        presenter.view = view
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        presenter.interactor = EditProfileInteractor(userService: UserService(imagesService: ImagesService()))
        
        view.output = presenter
        view.dataManager = EditProfileDataDisplayManager()
        
        return presenter
    }
}
