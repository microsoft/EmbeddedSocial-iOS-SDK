//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

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
        presenter.usersListModule = makeUserListModule(api: EmptyUsersListAPI(), noDataText: nil,
                                                       navigationController: navigationController, output: presenter)
        presenter.interactor = interactor
        presenter.moduleOutput = output
        
        if isLoggedInUser {
            presenter.backgroundUsersListModule = makeUserListModule(
                api: EmptyUsersListAPI(),
                noDataText: nil,
                navigationController: navigationController,
                output: presenter
            )
        }
        
        viewController.output = presenter
        viewController.theme = SocialPlus.theme
        
        moduleInput = presenter
    }
    
    private func makeUserListModule(api: UsersListAPI,
                                    noDataText: NSAttributedString?,
                                    navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output,
                                                     noDataText: noDataText)
        
        return UserListConfigurator().configure(with: settings)
    }
}
