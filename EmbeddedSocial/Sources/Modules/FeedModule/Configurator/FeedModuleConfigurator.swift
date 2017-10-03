//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

/*
 
*/

class FeedModuleConfigurator {
    
    var viewController: UIViewController!
    var moduleInput: FeedModuleInput!
    let cache: CacheType
    weak var userHolder: UserHolder?
    
    required init(cache: CacheType = SocialPlus.shared.cache, userHolder: UserHolder? = SocialPlus.shared) {
        self.cache = cache
        self.userHolder = userHolder
    }
    
    func configure(navigationController: UINavigationController? = nil,
                   moduleOutput: FeedModuleOutput? = nil,
                   myProfileOpener: MyProfileOpener? = SocialPlus.shared.coordinator,
                   loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator) {
        
        let viewController = StoryboardScene.FeedModule.feedModuleViewController.instantiate()
        let router = FeedModuleRouter()
        router.navigationController = navigationController
        router.myProfileOpener = myProfileOpener
        router.loginOpener = loginOpener
        
        /*
         let feed = .single(post: "3vErWk4EMrF"))
         let feed = .popular(type: .alltime))
         let feed = .user(user: "3v9gnzwILTS", scope: .recent)
         */
        
        let presenter = FeedModulePresenter()
    
    
        presenter.view = viewController
        presenter.router = router
        presenter.moduleOutput = moduleOutput
        presenter.userHolder = userHolder
        
        let interactor = FeedModuleInteractor()
        interactor.postService = TopicService(imagesService: ImagesService())
        interactor.searchService = SearchService()
        interactor.output = presenter
        
        presenter.interactor = interactor
        viewController.output = presenter
        
        router.postMenuModuleOutput = presenter
        router.viewController = viewController
        router.moduleInput = presenter
        
        self.viewController = viewController
        self.moduleInput = presenter
    }
}
