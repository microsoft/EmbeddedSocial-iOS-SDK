//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostMenuModuleConfigurator {
    
    var viewController: PostMenuModuleViewController!
    var moduleInput: PostMenuModuleInput!

    func configure(menuType: PostMenuType,
                   moduleOutput: PostMenuModuleOutput? = nil,
                   navigationController: UINavigationController? = nil,
                   myProfileHolder: UserHolder = SocialPlus.shared) {
        
        viewController = PostMenuModuleViewController()
        
        let router = PostMenuModuleRouter()
        router.navigationController = navigationController

        let strategy = CommonAuthorizedActionStrategy(loginParent: navigationController)
        let presenter = PostMenuModulePresenter(actionStrategy: strategy)
        presenter.view = viewController
        presenter.router = router
        presenter.menuType = menuType
        presenter.output = moduleOutput

        let interactor = PostMenuModuleInteractor()
        interactor.output = presenter
        interactor.socialService = SocialService()
        interactor.topicsService = TopicService(imagesService: ImagesService())
        interactor.commentService = CommentsService(imagesService: ImagesService())
        interactor.repliesService = RepliesService()

        presenter.interactor = interactor
        
        viewController.output = presenter
        
        viewController.view.backgroundColor = .clear
    }
}
