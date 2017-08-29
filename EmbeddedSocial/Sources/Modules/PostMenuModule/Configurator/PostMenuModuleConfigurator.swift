//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostMenuModuleConfigurator {
    
    var viewController: PostMenuModuleViewController!
    var moduleInput: PostMenuModuleInput!

    func configure(menuType: PostMenuType, moduleOutput: PostMenuModuleOutput? = nil, navigationComtroller: UINavigationController? = nil) {
        
        viewController = PostMenuModuleViewController()
        
        let router = PostMenuModuleRouter()
        router.navigationController = navigationComtroller

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
