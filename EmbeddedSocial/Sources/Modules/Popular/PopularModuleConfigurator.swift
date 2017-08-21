//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class PopularModuleConfigurator {
    
    var viewController: UIViewController!
    
    func configure(navigationController: UINavigationController) {
        
        let popularViewController = StoryboardScene.PopularModuleView.instantiatePopularModuleView()
        
        let router = PopularModuleRouter()
        router.navigationController = navigationController
        
        let presenter = PopularModulePresenter()
        presenter.view = popularViewController
        presenter.router = router
        presenter.configuredFeedModule = { navigationController, output in

            let configurator = FeedModuleConfigurator()
            
            configurator.configure(navigationController: navigationController, moduleOutput: output)
            
            return configurator
        }
        
        popularViewController.output = presenter
        
        viewController = popularViewController
    }
    
}
