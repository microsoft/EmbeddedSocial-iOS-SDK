//
//  CommentRepliesCommentRepliesConfigurator.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CommentRepliesModuleConfigurator {

    let viewController: CommentRepliesViewController
    
    init() {
        viewController = StoryboardScene.CommentReplies.instantiateCommentRepliesViewController()
    }
    
    func configure(commentView: CommentViewModel) {

        let router = CommentRepliesRouter()
        
        let repliesService = RepliesService()

        let presenter = CommentRepliesPresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.commentView = commentView

        let interactor = CommentRepliesInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        interactor.repliesService = repliesService
        viewController.output = presenter
    }

}
