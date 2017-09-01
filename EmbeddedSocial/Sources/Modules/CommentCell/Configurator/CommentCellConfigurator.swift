//
//  CommentCellCommentCellConfigurator.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 01/09/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

import UIKit

class CommentCellModuleConfigurator {


    func configure(cell: CommentCell, comment: Comment, navigationController: UINavigationController?) {

        let router = CommentCellRouter()
        router.navigationController = navigationController

        let presenter = CommentCellPresenter()
        presenter.view = cell
        presenter.router = router
        presenter.comment = comment

        let interactor = CommentCellInteractor()
        interactor.output = presenter
        interactor.likeService = LikesService()

        presenter.interactor = interactor
        cell.output = presenter
        
        cell.configure(comment: comment)
    }

}
