//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CommentCellModuleConfigurator {

    @discardableResult func configure(cell: CommentCell?, comment: Comment, navigationController: UINavigationController?) -> CommentCellModuleInput {

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
        cell?.output = presenter
        
        cell?.configure(comment: comment)
        
        return presenter
    }

}
