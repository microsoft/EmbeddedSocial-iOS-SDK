//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class PostDetailModuleConfigurator {
    
    let viewController: PostDetailViewController
    
    init() {
        viewController = StoryboardScene.PostDetail.instantiatePostDetailViewController()
    }

    func configure(post: Post) {

        let router = PostDetailRouter()

        let presenter = PostDetailPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.post = post

        let interactor = PostDetailInteractor()
        interactor.output = presenter
        
        let commentsService = CommentsService(imagesService: ImagesService())
        interactor.commentsService = commentsService
        let likeService = LikesService()
        interactor.likeService = likeService

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
