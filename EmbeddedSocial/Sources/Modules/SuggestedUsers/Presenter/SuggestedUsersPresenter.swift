//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class SuggestedUsersPresenter: SuggestedUsersViewOutput {
    weak var view: SuggestedUsersViewInput!
    var usersList: UserListModuleInput!
    
    func viewIsReady() {
        view.setupInitialState(userListView: usersList.listView)
        usersList.setupInitialState()
    }
}

extension SuggestedUsersPresenter: UserListModuleOutput {

    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        view.showError(error)
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        view.showError(error)
    }
}
