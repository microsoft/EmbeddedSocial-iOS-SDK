//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class FollowersPresenter: FollowersViewOutput {
    weak var view: FollowersViewInput!
    var usersList: UserListModuleInput!
    weak var moduleOutput: FollowersModuleOutput?
    
    func viewIsReady() {
        view.setupInitialState(userListView: usersList.listView)
        usersList.setupInitialState()
    }
}

extension FollowersPresenter: UserListModuleOutput {
    
    func didUpdateFollowStatus(for user: User) {
        guard let followStatus = user.followerStatus else { return }
        moduleOutput?.didUpdateFollowersStatus(newStatus: followStatus)
    }

    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        view.showError(error)
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        view.showError(error)
    }
}
