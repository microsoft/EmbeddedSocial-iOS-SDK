//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class PopularModuleConfigurator {
    
    var viewController: UIViewController!
    
    func configure() {
        
        let view = StoryboardScene.PopularModuleView.instantiatePopularModuleView()
        
        let presenter = PopularModulePresenter()
        presenter.view = view
        presenter.feedModule = configuredFeedConfigurator.moduleInput
        
        view.output = presenter
        
        let feedViewController = configuredFeedConfigurator.viewController!
     
        feedViewController.willMove(toParentViewController: view)
        view.addChildViewController(feedViewController)
        view.container.addSubview(feedViewController.view)
        feedViewController.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        feedViewController.didMove(toParentViewController: view)
    }
    
    private lazy var configuredFeedConfigurator: FeedModuleConfigurator = {
       
        let configurator = FeedModuleConfigurator()
        
        configurator.configure()
        
        return configurator
        
    }()
    
}
