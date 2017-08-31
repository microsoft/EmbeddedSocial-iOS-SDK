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

    func configure(postViewModel: PostViewModel, scrollType: CommentsScrollType, postPresenter: FeedModulePresenter) {
        
        let router = PostDetailRouter()

        let presenter = PostDetailPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.postViewModel = postViewModel
        presenter.postViewModelActionsHandler = postPresenter

        let interactor = PostDetailInteractor()
        interactor.output = presenter
        
        let commentsService = CommentsService(imagesService: ImagesService())
        interactor.commentsService = commentsService
        let likeService = LikesService()
        interactor.likeService = likeService
        let topicService = TopicService()
        interactor.topicService = topicService
        presenter.scrollType = scrollType
        
        presenter.interactor = interactor
        viewController.output = presenter
        
    }

}
