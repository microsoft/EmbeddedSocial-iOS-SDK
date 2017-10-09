//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LikesListPresenter {
    weak var view: LikesListViewInput!
    var interactor: LikesListInteractorInput!
    var usersListModule: UserListModuleInput!
}

extension LikesListPresenter: LikesListViewOutput {
    
    func viewIsReady() {
        view.setupInitialState(userListView: usersListModule.listView)
        usersListModule.setupInitialState()
    }
}

extension LikesListPresenter: UserListModuleOutput {
    
    func didFailToPerformSocialRequest(listView: UIView, error: Error) {
        view.showError(error)
    }
    
    func didFailToLoadList(listView: UIView, error: Error) {
        view.showError(error)
    }
}
