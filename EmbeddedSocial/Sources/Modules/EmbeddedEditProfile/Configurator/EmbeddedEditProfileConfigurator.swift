//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct EmbeddedEditProfileConfigurator {
    let view: EmbeddedEditProfileView
    
    init() {
        view = EmbeddedEditProfileView()
    }
    
    func configure(user: User, moduleOutput: EmbeddedEditProfileModuleOutput?) -> EmbeddedEditProfileModuleInput {
        let router = EmbeddedEditProfileRouter()
        
        let presenter = EmbeddedEditProfilePresenter(user: user)
        presenter.view = view
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        presenter.interactor = EmbeddedEditProfileInteractor(userService: UserService(imagesService: ImagesService()))
        
        let dataManager = EmbeddedEditProfileDataDisplayManager()
        dataManager.theme = SocialPlus.theme
        
        view.output = presenter
        view.dataManager = dataManager
        view.theme = SocialPlus.theme
        
        return presenter
    }
}
