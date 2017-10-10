//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class CommentCellModuleConfigurator {

    @discardableResult func configure(cell: CommentCell?,
                                      comment: Comment,
                                      navigationController: UINavigationController?,
                                      moduleOutput: CommentCellModuleOutout ,
                                      myProfileHolder: UserHolder? = SocialPlus.shared) -> CommentCellModuleInput {

        let router = CommentCellRouter()
        router.navigationController = navigationController

        let strategy = CommonAuthorizedActionStrategy(loginParent: navigationController)
        let presenter = CommentCellPresenter(actionStrategy: strategy)
        presenter.view = cell
        presenter.router = router
        presenter.comment = comment
        presenter.moduleOutput = moduleOutput

        let interactor = CommentCellInteractor()
        interactor.output = presenter
        interactor.likeService = LikesService()

        presenter.interactor = interactor
        router.postMenuModuleOutput = presenter
        router.moduleInput = presenter
        cell?.output = presenter
        
        cell?.configure(comment: comment)
        
        cell?.theme = SocialPlus.theme
        
        return presenter
    }

}
