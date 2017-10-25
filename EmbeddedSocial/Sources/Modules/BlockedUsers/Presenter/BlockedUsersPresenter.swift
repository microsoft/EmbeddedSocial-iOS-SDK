//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class BlockedUsersPresenter {
    weak var view: BlockedUsersViewInput!
    var usersListModule: UserListModuleInput!
}

extension BlockedUsersPresenter: BlockedUsersViewOutput {
    
    func viewIsReady() {
        view.setupInitialState(userListView: usersListModule.listView)
        usersListModule.setupInitialState()
    }
}

extension BlockedUsersPresenter: UserListModuleOutput {

    func didUpdateFollowStatus(for user: User) {
        usersListModule.removeUser(user)
    }
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        view.showError(error)
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        view.showError(error)
    }
}
