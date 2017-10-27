//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

class SuggestedUsersPresenter: SuggestedUsersViewOutput {
    weak var view: SuggestedUsersViewInput!
    var usersList: UserListModuleInput!
    var interactor: SuggestedUsersInteractorInput!
    
    private let userHolder: UserHolder
    
    init(userHolder: UserHolder) {
        self.userHolder = userHolder
    }
    
    func viewIsReady() {
        if interactor.isFriendsListPermissionGranted {
            setupInitialState()
        } else {
            requestPermissions()
        }
    }
    
    private func setupInitialState() {
        view.setupInitialState(userListView: usersList.listView)
        usersList.setupInitialState()
    }
    
    private func requestPermissions() {
        interactor.requestFriendsListPermission(parentViewController: view as? UIViewController) { [weak self] result in
            if let creds = result.value {
                var user = self?.userHolder.me
                user?.credentials = creds
                self?.userHolder.me = user
                self?.setupInitialState()
            } else {
                strongSelf.view.showError(result.error ?? APIError.unknown)
            }
        }
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
