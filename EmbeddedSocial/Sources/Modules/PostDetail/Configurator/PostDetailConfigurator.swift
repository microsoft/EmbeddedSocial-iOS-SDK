//
//  PostDetailPostDetailConfigurator.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 31/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class PostDetailModuleConfigurator {

    func configure(viewController: PostDetailViewController, post: Post) {

        let router = PostDetailRouter()

        let presenter = PostDetailPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.post = post

        let interactor = PostDetailInteractor()
        interactor.output = presenter
        let commentsService = CommentsService()
        interactor.commentsService = commentsService

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
