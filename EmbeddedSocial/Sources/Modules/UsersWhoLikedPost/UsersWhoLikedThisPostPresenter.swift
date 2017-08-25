//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UsersWhoLikedPostPresenter {
    weak var view: UsersWhoLikedPostViewInput!
    var interactor: UsersWhoLikedPostInteractorInput!
    var usersListModule: UserListModuleInput!
}

extension UsersWhoLikedPostPresenter: UsersWhoLikedPostViewOutput {
    
    func viewIsReady() {
        view.setupInitialState(userListView: usersListModule.listView)
        usersListModule.setupInitialState()
    }
}

extension UsersWhoLikedPostPresenter: UserListModuleOutput {
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        view.showError(error)
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        view.showError(error)
    }
}
