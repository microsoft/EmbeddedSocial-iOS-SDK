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
    
    func configure(feed: FeedType? = nil) {
        
        let viewController = StoryboardScene.Home.instantiateHomeViewController()
        let router = HomeRouter()
        
        /*
         let feed = .single(post: "3vErWk4EMrF"))
         let feed = .popular(type: .alltime))
         let feed = .user(user: "3v9gnzwILTS", scope: .recent)
         */
        
        let presenter = HomePresenter()
        
        if let feed = feed {
            presenter.setFeed(feed)
        }
        
        presenter.view = viewController
        presenter.router = router
        
        let interactor = HomeInteractor()
        interactor.postService = TopicService(cache: SocialPlus.shared.cache) // TODO: inject this
        interactor.output = presenter
        
        presenter.interactor = interactor
        viewController.output = presenter
        router.viewController = viewController
        
        self.viewController = viewController
        self.moduleInput = presenter
    }
    
}
