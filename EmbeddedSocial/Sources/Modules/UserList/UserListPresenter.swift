//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListPresenter: UserListViewOutput {
    var view: UserListViewInput!
    var interactor: UserListInteractorInput!
    
    weak var moduleOutput: UserListModuleOutput?
}

extension UserListPresenter: UserListModuleInput {
    
    var listView: UIView {
        guard let view = view as? UIView else {
            fatalError("View not set")
        }
        return view
    }
    
    func setupInitialState() {
        view.setupInitialState()
    }
    
    func loadList() {
        interactor.getUsers { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            if let users = result.value {
                strongSelf.view.setUsers(users)
                strongSelf.moduleOutput?.didLoadList(listView: strongSelf.listView)
            } else {
                strongSelf.moduleOutput?.didFailToLoadList(listView: strongSelf.listView, result.error ?? APIError.unknown)
            }
        }
    }
}
