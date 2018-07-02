//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class SearchPeopleConfigurator {
    let viewController: SearchPeopleViewController
    private(set) var moduleInput: SearchPeopleModuleInput!
    
    init() {
        viewController = StoryboardScene.SearchPeople.searchPeopleViewController.instantiate()
    }
    
    func configure(isLoggedInUser: Bool, navigationController: UINavigationController?, output: SearchPeopleModuleOutput?) {
        let interactor = SearchPeopleInteractor()
        
        let presenter = SearchPeoplePresenter()
        
        presenter.view = viewController
        presenter.usersListModule = makeUserListModule(api: EmptyUsersListAPI(),
                                                       navigationController: navigationController,
                                                       output: presenter)
        presenter.interactor = interactor
        presenter.moduleOutput = output
        
        if isLoggedInUser {
            presenter.backgroundUsersListModule = makeUserListModule(
                api: PopularUsersAPI(socialService: SocialService()),
                navigationController: navigationController,
                output: presenter
            )
        }
        
        viewController.output = presenter
        viewController.theme = AppConfiguration.shared.theme
        
        moduleInput = presenter
    }
    
    private func makeUserListModule(api: UsersListAPI,
                                    navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output)
        
        return UserListConfigurator().configure(with: settings)
    }
}
