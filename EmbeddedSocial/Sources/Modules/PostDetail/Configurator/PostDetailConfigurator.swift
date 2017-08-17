//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum CommentsScrollType {
    case none
    case bottom
}

class PostDetailModuleConfigurator {
    
    let viewController: PostDetailViewController
    
    init() {
        viewController = StoryboardScene.PostDetail.instantiatePostDetailViewController()
    }

    func configure(post: Post, navigationController: UINavigationController? = nil, scrollType: CommentsScrollType) {
        
        let router = PostDetailRouter()

        let presenter = PostDetailPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.post = post
        
        let feedConfigurator = FeedModuleConfigurator(cache: SocialPlus.shared.cache)
        feedConfigurator.configure(navigationController: navigationController, moduleOutput: presenter)
        
        feedConfigurator.moduleInput.refreshData()

        let interactor = PostDetailInteractor()
        interactor.output = presenter
        
        let commentsService = CommentsService(imagesService: ImagesService())
        interactor.commentsService = commentsService
        let likeService = LikesService()
        interactor.likeService = likeService
        presenter.scrollType = scrollType
        
        presenter.interactor = interactor
        viewController.output = presenter
        
        
        presenter.feedViewController = feedConfigurator.viewController
        presenter.feedModuleInput = feedConfigurator.moduleInput
        
        
    }

}
