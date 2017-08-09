//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UsersListAPI {
    func getUsersList(cursor: String?, limit: Int, completion: @escaping (Result<UsersListResponse>) -> Void)
}

struct UserListConfigurator {
    func configure(api: UsersListAPI, me: User = SocialPlus.shared.me, output: UserListModuleOutput?) -> UserListModuleInput {
        let view = UserListView()
        
        let presenter = UserListPresenter()
        presenter.view = view
        presenter.moduleOutput = output
        presenter.interactor = UserListInteractor(api: api, socialService: SocialService())
        
        view.output = presenter
        view.dataManager = UserListDataDisplayManager(me: me)
        
        return presenter
    }
}
