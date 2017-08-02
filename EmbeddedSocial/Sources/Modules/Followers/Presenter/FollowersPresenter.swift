//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FollowersPresenter: FollowersViewOutput {
    weak var view: FollowersViewInput!
    var usersList: UserListModuleInput!
    
    func viewIsReady() {
        view.setupInitialState(userListView: usersList.listView)
        usersList.setupInitialState()
        usersList.loadList()
    }
}

extension FollowersPresenter: UserListModuleOutput {
    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        view.showError(error)
    }

    func didTriggerUserAction(_ user: User) {
        
    }

    func didSelectListItem(listView: UIView, at indexPath: IndexPath) {
        print("didSelectListItem \(indexPath)")
    }
    
    func didLoadList(listView: UIView) {
        
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        view.showError(error)
    }
}
