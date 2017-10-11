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
        viewController = StoryboardScene.PostDetail.postDetailViewController.instantiate()
    }
    
    func configure(topicHandle: PostHandle,
                   scrollType: CommentsScrollType,
                   myProfileHolder: UserHolder = SocialPlus.shared,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator,
                   navigationController: UINavigationController? = nil,
                   pageSize: Int = AppConfiguration.shared.settings.numberOfCommentsToShow) {
        
        let router = PostDetailRouter()
        router.loginOpener = loginOpener

        let presenter = PostDetailPresenter(myProfileHolder: myProfileHolder, pageSize: pageSize)
        presenter.view = viewController
        presenter.router = router
        presenter.topicHandle = topicHandle
        
        let interactor = PostDetailInteractor()
        interactor.output = presenter
        
        let imageService = ImagesService()
        let commentsService = CommentsService(imagesService: imageService)
        interactor.commentsService = commentsService
        let topicService = TopicService(imagesService: imageService)

        interactor.topicService = topicService
        presenter.scrollType = scrollType
        
        presenter.interactor = interactor
        viewController.output = presenter
        viewController.theme = AppConfiguration.shared.theme
        
        let feedConfigurator = FeedModuleConfigurator(cache: SocialPlus.shared.cache)
        feedConfigurator.configure(navigationController: navigationController, moduleOutput: presenter)
        
        feedConfigurator.moduleInput.feedType = .single(post: topicHandle)
        presenter.feedViewController = feedConfigurator.viewController
        presenter.feedModuleInput = feedConfigurator.moduleInput
    }

}
