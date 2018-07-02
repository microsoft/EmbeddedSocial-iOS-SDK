//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class SearchTopicsConfigurator {
    let viewController: SearchTopicsViewController
    private(set) var moduleInput: SearchTopicsModuleInput!
    
    init() {
        viewController = StoryboardScene.SearchTopics.searchTopicsViewController.instantiate()
    }
    
    func configure(navigationController: UINavigationController?, output: SearchTopicsModuleOutput?) {
        let presenter = SearchTopicsPresenter()
        
        presenter.view = viewController
        presenter.interactor = SearchTopicsInteractor()
        presenter.moduleOutput = output
        
        let feedConfigurator = FeedModuleConfigurator()
        feedConfigurator.configure(navigationController: navigationController, moduleOutput: presenter)
        presenter.feedModule = feedConfigurator.moduleInput
        presenter.feedViewController = feedConfigurator.viewController
        
        var trendingTopicsConfigurator = TrendingTopicsConfigurator()
        trendingTopicsConfigurator.configure(output: presenter)
        presenter.trendingTopicsModule = trendingTopicsConfigurator.moduleInput
        
        viewController.output = presenter
        viewController.theme = AppConfiguration.shared.theme
        
        moduleInput = presenter
    }
}
