//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListPresenter {
    var view: UserListViewInput!
    var interactor: UserListInteractorInput!
    weak var moduleOutput: UserListModuleOutput?
}

extension UserListPresenter: UserListViewOutput {
    
    func onItemAction(item: UserListItem) {
        moduleOutput?.didTriggerUserAction(item.user)
        
        view.setIsLoading(true, itemAt: item.indexPath)
        
        interactor.processSocialRequest(to: item.user) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.view.setIsLoading(false, itemAt: item.indexPath)
            
            if let newStatus = result.value {
                var user = item.user
                user.followerStatus = newStatus
                strongSelf.view.updateListItem(with: user, at: item.indexPath)
            } else {
                strongSelf.moduleOutput?.didFailToPerformSocialRequest(listView: strongSelf.listView,
                                                                       error: result.error ?? APIError.unknown)
            }
        }
    }
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
                strongSelf.moduleOutput?.didFailToLoadList(listView: strongSelf.listView, error: result.error ?? APIError.unknown)
            }
        }
    }
}
