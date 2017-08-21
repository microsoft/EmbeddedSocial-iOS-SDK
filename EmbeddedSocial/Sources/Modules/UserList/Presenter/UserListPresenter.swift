//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListPresenter {
    typealias ListState = PaginatedResponse<User, String>
    
    var view: UserListViewInput!
    var interactor: UserListInteractorInput!
    weak var moduleOutput: UserListModuleOutput?
    
    fileprivate var listState = ListState()
    
    fileprivate var isLoadingList = false {
        didSet {
            view.setIsLoading(isLoadingList)
        }
    }
    
    func loadNextPage() {
        isLoadingList = true
        
        interactor.getUsersList(cursor: listState.cursor, limit: Constants.UserList.pageSize) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            if result.isSuccess {
                strongSelf.listState = strongSelf.listState.reduce(result: result)
                strongSelf.view.setUsers(strongSelf.listState.items)
                strongSelf.moduleOutput?.didUpdateList(listView: strongSelf.listView)
            } else {
                strongSelf.moduleOutput?.didFailToLoadList(listView: strongSelf.listView, error: result.error ?? APIError.unknown)
            }
            
            strongSelf.isLoadingList = false
        }
    }
}

extension UserListPresenter: UserListViewOutput {
    
    func onItemAction(item: UserListItem) {
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
        guard !isLoadingList, listState.hasMore else {
            return
        }
        loadNextPage()
    }
    
    func onItemSelected(at indexPath: IndexPath) {
        moduleOutput?.didSelectListItem(listView: listView, at: indexPath)
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
        listState = ListState()
        isLoadingList = false
        loadNextPage()
    }
    
    func setListHeaderView(_ headerView: UIView?) {
        view.setListHeaderView(headerView)
    }
}
