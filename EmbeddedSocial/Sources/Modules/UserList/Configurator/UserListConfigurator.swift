//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UsersListAPI {
    func getUsersList(completion: @escaping (Result<[User]>) -> Void)
}

struct UserListConfigurator {
    func configure(api: UsersListAPI, output: UserListModuleOutput?) -> UserListModuleInput {
        let view = UserListView()
        
        let presenter = UserListPresenter()
        presenter.view = view
        presenter.moduleOutput = output
        presenter.interactor = UserListInteractor(api: api, socialService: SocialService())
        
        view.output = presenter
        view.dataManager = UserListDataDisplayManager()
        
        return presenter
    }
}
