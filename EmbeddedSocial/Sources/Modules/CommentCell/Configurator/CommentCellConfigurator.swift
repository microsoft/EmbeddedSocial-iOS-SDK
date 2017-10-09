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
                                      myProfileHolder: UserHolder? = SocialPlus.shared,
                                      loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator) -> CommentCellModuleInput {

        let router = CommentCellRouter()
        router.navigationController = navigationController
        router.loginOpener = loginOpener

        let presenter = CommentCellPresenter()
        presenter.view = cell
        presenter.router = router
        presenter.comment = comment
        presenter.moduleOutput = moduleOutput
        presenter.myProfileHolder = myProfileHolder

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
