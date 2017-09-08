//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchTopicsConfigurator {
    let viewController: SearchTopicsViewController
    private(set) var moduleInput: SearchTopicsModuleInput!
    
    init() {
        viewController = StoryboardScene.SearchTopics.instantiateSearchTopicsViewController()
    }
    
    func configure(navigationController: UINavigationController?, output: SearchTopicsModuleOutput?) {
        let presenter = SearchTopicsPresenter()
        
        let feedConfigurator = FeedModuleConfigurator()
        feedConfigurator.configure(navigationController: navigationController, moduleOutput: presenter)
        
        presenter.view = viewController
        presenter.interactor = SearchTopicsInteractor()
        presenter.moduleOutput = output
        presenter.feedModule = feedConfigurator.moduleInput
        presenter.feedViewController = feedConfigurator.viewController
        
        viewController.output = presenter
        
        moduleInput = presenter
    }
}
