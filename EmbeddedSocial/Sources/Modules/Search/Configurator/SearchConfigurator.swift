//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SearchConfigurator {
    
    let viewController: SearchViewController
    private(set) var moduleInput: SearchModuleInput!
    
    init() {
        viewController = StoryboardScene.Search.searchViewController.instantiate()
    }
    
    func configure(isLoggedInUser: Bool, navigationController: UINavigationController?) {
        let presenter = SearchPresenter()

        let peopleConf = SearchPeopleConfigurator()
        peopleConf.configure(isLoggedInUser: isLoggedInUser, navigationController: navigationController, output: presenter)
        
        let topicsConf = SearchTopicsConfigurator()
        topicsConf.configure(navigationController: navigationController, output: presenter)

        presenter.view = viewController
        presenter.peopleSearchModule = peopleConf.moduleInput
        presenter.topicsSearchModule = topicsConf.moduleInput
        presenter.interactor = SearchInteractor()
        
        viewController.output = presenter
        viewController.theme = SocialPlus.theme
        
        moduleInput = presenter
    }
}
