//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CommentRepliesModuleConfigurator {

    let viewController: CommentRepliesViewController
    
    init() {
        viewController = StoryboardScene.CommentReplies.instantiateCommentRepliesViewController()
    }
    
    func configure(commentView: CommentViewModel, postDetailsPresenter: PostDetailPresenter?) {

        let router = CommentRepliesRouter()
        
        let repliesService = RepliesService()

        let presenter = CommentRepliesPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.commentView = commentView
        
        let interactor = CommentRepliesInteractor()
        interactor.output = presenter

        let likeService = LikesService()
        interactor.likeService = likeService
        
        presenter.interactor = interactor
        interactor.repliesService = repliesService
        viewController.output = presenter
        
        postDetailsPresenter?.repliesPresenter = presenter
    }

}
