//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

/*
 
 */

class HomeModuleConfigurator {
    
    class func configure() -> UIViewController {

        let viewController = StoryboardScene.Home.instantiateHomeViewController()
        let router = HomeRouter()

//        let presenter = HomePresenter(configuration: .single(post: "3vErWk4EMrF"))
//        let presenter = HomePresenter(configuration: .popular(type: .alltime))
        let presenter = HomePresenter(configuration: .user(user: "3v9gnzwILTS", scope: .recent))
        presenter.view = viewController
        presenter.router = router

        let interactor = HomeInteractor()
        interactor.postService = TopicService(cache: SocialPlus.shared.cache) // TODO: inject this
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
