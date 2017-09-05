//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListPresenter {
    var view: UserListViewInput!
    var interactor: UserListInteractorInput!
    weak var moduleOutput: UserListModuleOutput?
    var router: UserListRouterInput!
    fileprivate let myProfileHolder: UserHolder
    
    init(myProfileHolder: UserHolder) {
        self.myProfileHolder = myProfileHolder
    }
    
    func loadNextPage() {
        interactor.getNextListPage { [weak self] result in
            guard let strongSelf = self else { return }
            
            if let users = result.value {
                strongSelf.view.setUsers(users)
                strongSelf.moduleOutput?.didUpdateList(listView: strongSelf.listView)
            } else {
                strongSelf.moduleOutput?.didFailToLoadList(listView: strongSelf.listView, error: result.error ?? APIError.unknown)
            }
        }
    }
}

extension UserListPresenter: UserListInteractorOutput {
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        view.setIsLoading(isLoading)
    }
}

extension UserListPresenter: UserListViewOutput {
    
    func onItemAction(item: UserListItem) {
        
        guard myProfileHolder.me != nil else {
            router.openLogin()
            return
        }
        
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
                strongSelf.moduleOutput?.didUpdateFollowStatus(listView: strongSelf.listView,
                                                               followStatus: newStatus,
                                                               forUserAt: item.indexPath)
            } else {
                strongSelf.moduleOutput?.didFailToPerformSocialRequest(listView: strongSelf.listView,
                                                                       error: result.error ?? APIError.unknown)
            }
        }
    }
    
    func onReachingEndOfPage() {
        guard !interactor.isLoadingList, interactor.listHasMoreItems else {
            return
        }
        loadNextPage()
    }
    
    func onItemSelected(_ item: UserListItem) {
        moduleOutput?.didSelectListItem(listView: listView, at: item.indexPath)
        if item.user.isMe {
            router.openMyProfile()
        } else {
            router.openUserProfile(item.user.uid)
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
        loadNextPage()
    }
    
    func reload(with api: UsersListAPI) {
        interactor.setAPI(api)
        loadNextPage()
    }
    
    func setListHeaderView(_ headerView: UIView?) {
        view.setListHeaderView(headerView)
    }
}
