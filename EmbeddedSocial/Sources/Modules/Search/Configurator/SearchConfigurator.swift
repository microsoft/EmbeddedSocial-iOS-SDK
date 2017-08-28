//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SearchConfigurator {
    
    let viewController: SearchViewController
    
    init() {
        viewController = StoryboardScene.Search.instantiateSearchViewController()
    }
    
    func configure(isLoggedInUser: Bool, navigationController: UINavigationController?) {
        let conf = SearchPeopleConfigurator()
        let peopleSearchModule = conf.configure(isLoggedInUser: isLoggedInUser, navigationController: navigationController)
        
        let presenter = SearchPresenter()
        presenter.view = viewController
        presenter.peopleSearchModule = peopleSearchModule
        presenter.interactor = SearchInteractor()
        
        viewController.output = presenter
    }
}
