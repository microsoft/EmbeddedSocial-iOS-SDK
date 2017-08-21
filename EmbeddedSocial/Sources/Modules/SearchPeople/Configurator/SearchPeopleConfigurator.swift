//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SearchPeopleConfigurator {
    let viewController: SearchPeopleViewController
    
    init() {
        viewController = StoryboardScene.SearchPeople.instantiateSearchPeopleViewController()
    }
    
    func configure() -> SearchPeopleModuleInput {
        let interactor = SearchPeopleInteractor()
        
        let api = QueryPeopleAPI(query: "", searchService: SearchService())
        let conf = UserListConfigurator()
        let usersListModule = conf.configure(api: api, output: nil)
        
        let presenter = SearchPeoplePresenter()
        presenter.view = viewController
        presenter.usersListModule = usersListModule
        presenter.interactor = interactor
        
        viewController.output = presenter
        
        return presenter
    }
}
