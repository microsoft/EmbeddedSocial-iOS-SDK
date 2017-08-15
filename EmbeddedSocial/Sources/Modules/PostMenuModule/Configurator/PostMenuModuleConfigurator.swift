//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostMenuModuleConfigurator {
    
    var viewController: PostMenuModuleViewController!
    var moduleInput: PostMenuModuleModuleInput!

    func configure(menuType: PostMenuType, moduleOutput: PostMenuModuleModuleOutput? = nil) {
        
        viewController = PostMenuModuleViewController()
        
        let router = PostMenuModuleRouter()

        let presenter = PostMenuModulePresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.menuType = menuType
        presenter.output = moduleOutput

        let interactor = PostMenuModuleInteractor()
        interactor.output = presenter
        interactor.socialService = SocialService()
        interactor.topicsService = TopicService(imagesService: ImagesService())

        presenter.interactor = interactor
        
        viewController.output = presenter
        
        viewController.view.backgroundColor = UIColor.clear
    }
}
