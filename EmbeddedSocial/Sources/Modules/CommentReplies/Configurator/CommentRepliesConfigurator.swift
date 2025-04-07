//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum RepliesScrollType {
    case none
    case bottom
}

class CommentRepliesModuleConfigurator {

    let viewController: CommentRepliesViewController
    
    init() {
        viewController = StoryboardScene.CommentReplies.commentRepliesViewController.instantiate()
    }
    
    func configure(commentModule: CommentCellModuleProtocol,
                   scrollType: RepliesScrollType,
                   myProfileHolder: UserHolder = SocialPlus.shared,
                   pageSize: Int = AppConfiguration.shared.settings.numberOfRepliesToShow,
                   navigationController: UINavigationController?) {
        
        let router = CommentRepliesRouter()
        router.navigationController = navigationController
        
        let repliesService = RepliesService()
        
        let strategy = CommonAuthorizedActionStrategy(loginParent: navigationController)
        let presenter = CommentRepliesPresenter(pageSize: pageSize, actionStrategy: strategy)
        presenter.comment = commentModule.mainComment()
        presenter.view = viewController
        router.moduleInput = presenter
        router.navigationController = navigationController
        router.postMenuModuleOutput = presenter
        presenter.router = router
        presenter.scrollType = scrollType
        presenter.commentModuleOutput = commentModule
        let interactor = CommentRepliesInteractor()
        interactor.output = presenter
        
        let likeService = LikesService()
        interactor.likeService = likeService
        
        presenter.interactor = interactor
        
        interactor.repliesService = repliesService
        viewController.output = presenter
        viewController.theme = AppConfiguration.shared.theme
    }

}
