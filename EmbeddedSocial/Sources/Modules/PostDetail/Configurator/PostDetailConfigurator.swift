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
        viewController = StoryboardScene.PostDetail.instantiatePostDetailViewController()
    }
    
    func configure(postViewModel: PostViewModel,
                   scrollType: CommentsScrollType,
                   myProfileHolder: UserHolder = SocialPlus.shared,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator,
                   navigationController: UINavigationController? = nil) {
        
        let router = PostDetailRouter()
        router.loginOpener = loginOpener

        let presenter = PostDetailPresenter(myProfileHolder: myProfileHolder)
        presenter.view = viewController
        presenter.router = router
        presenter.postViewModel = postViewModel
        
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
        
        let feedConfigurator = FeedModuleConfigurator(cache: SocialPlus.shared.cache)
        feedConfigurator.configure(navigationController: navigationController, moduleOutput: presenter)
        
        feedConfigurator.moduleInput.feedType = .single(post: postViewModel.topicHandle)
        presenter.feedViewController = feedConfigurator.viewController
        presenter.feedModuleInput = feedConfigurator.moduleInput
    }

}
