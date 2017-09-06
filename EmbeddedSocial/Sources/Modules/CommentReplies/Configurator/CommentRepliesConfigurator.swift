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
        viewController = StoryboardScene.CommentReplies.instantiateCommentRepliesViewController()
    }
    
    func configure(commentModule: CommentCellModuleProtocol, scrollType: RepliesScrollType, myProfileHolder: UserHolder = SocialPlus.shared,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator) {
        let router = CommentRepliesRouter()
        router.loginOpener = loginOpener
        
        let repliesService = RepliesService()
        
        let presenter = CommentRepliesPresenter(myProfileHolder: myProfileHolder)
        presenter.comment = commentModule.mainComment()
        presenter.commentCell = commentModule.cell()
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
        
    }

}
