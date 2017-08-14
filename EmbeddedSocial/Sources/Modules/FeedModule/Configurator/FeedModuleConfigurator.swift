//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

/*
 
 */

class FeedModuleConfigurator {
    
    weak var viewController: UIViewController!
    weak var moduleInput: FeedModuleInput!
    let cache: CacheType
    weak var userHolder: UserHolder?
    
    required init(cache: CacheType, userHolder: UserHolder? = SocialPlus.shared) {
        self.cache = cache
        self.userHolder = userHolder
    }
    
    func configure(navigationController: UINavigationController? = nil,
                   moduleOutput: FeedModuleOutput? = nil) {
        
        let viewController = StoryboardScene.FeedModule.instantiateFeedModuleViewController()
        let router = FeedModuleRouter()
        router.navigationController = navigationController
        
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
        interactor.postService = TopicService(cache: cache)
        interactor.output = presenter
        
        presenter.interactor = interactor
        viewController.output = presenter
        
        router.postMenuModuleOutput = presenter
        router.viewController = viewController
        
        self.viewController = viewController
        self.moduleInput = presenter
    }
    
}
