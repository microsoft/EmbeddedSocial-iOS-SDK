//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

enum RepliesScrollType {
    case none
    case bottom
}

class CommentRepliesModuleConfigurator {

    let viewController: CommentRepliesViewController
    
    init() {
        viewController = StoryboardScene.CommentReplies.commentRepliesViewController.instantiate()
    }
    
    func configure(commentModule: CommentCellModuleProtocol,
                   scrollType: RepliesScrollType,
                   myProfileHolder: UserHolder = SocialPlus.shared,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator,
                   pageSize: Int = SocialPlus.settings.numberOfRepliesToShow) {
        
        let router = CommentRepliesRouter()
        router.loginOpener = loginOpener
        
        let repliesService = RepliesService()
        
        let presenter = CommentRepliesPresenter(myProfileHolder: myProfileHolder, pageSize: pageSize)
        presenter.comment = commentModule.mainComment()
        presenter.commentCell = commentModule.cell()
        presenter.commentCell.separator.isHidden = false
        presenter.view = viewController
        presenter.router = router
        presenter.scrollType = scrollType
        let interactor = CommentRepliesInteractor()
        interactor.output = presenter
        
        let likeService = LikesService()
        interactor.likeService = likeService
        
        presenter.interactor = interactor
        
        interactor.repliesService = repliesService
        viewController.output = presenter
        
        viewController.theme = SocialPlus.theme
    }

}
