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
    
    var noDataText: NSAttributedString?
    var noDataView: UIView?
    
    fileprivate var isAnimatingPullToRefresh = false
    fileprivate let actionStrategy: AuthorizedActionStrategy
    
    init(actionStrategy: AuthorizedActionStrategy) {
        self.actionStrategy = actionStrategy
    }
    
    func loadNextPage() {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._loadNextPage() }
    }
    
    private func _loadNextPage() {
        view.setIsEmpty(false)
        
        interactor.getNextListPage { [weak self] result in
            self?.processUsersResult(result)
        }
    }
    
    fileprivate func processUsersResult(_ result: Result<[User]>) {
        if let users = result.value {
            view.setUsers(users)
            moduleOutput?.didUpdateList(listView, with: users)
        } else {
            moduleOutput?.didFailToLoadList(listView: listView, error: result.error ?? APIError.unknown)
        }
        
        view.setIsEmpty(result.value?.isEmpty ?? true)
    }
}

extension UserListPresenter: UserListInteractorOutput {
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        guard !isAnimatingPullToRefresh else { return }
        view.setIsLoading(isLoading)
    }
}

extension UserListPresenter: UserListViewOutput {
    
    func onItemAction(item: UserListItem) {
        actionStrategy.executeOrPromptLogin { [weak self] in self?._onItemAction(item: item) }
    }
    
    private func _onItemAction(item: UserListItem) {
        view.setIsLoading(true, item: item)
        
        interactor.processSocialRequest(to: item.user) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.view.setIsLoading(false, item: item)
            
            if let newStatus = result.value {
                var user = item.user
                user.followerStatus = newStatus
                strongSelf.view.updateListItem(with: user)
                strongSelf.moduleOutput?.didUpdateFollowStatus(for: user)
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
        if item.user.isMe {
            router.openMyProfile()
        } else {
            router.openUserProfile(item.user.uid)
        }
    }
    
    func onPullToRefresh() {
        isAnimatingPullToRefresh = true
        view.setIsEmpty(false)

        interactor.reloadList { [weak self] result in
            self?.isAnimatingPullToRefresh = false
            self?.view.endPullToRefreshAnimation()
            self?.processUsersResult(result)
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
        view.setNoDataText(noDataText)
        view.setNoDataView(noDataView)
        loadNextPage()
    }
    
    func reload(with api: UsersListAPI) {
        interactor.setAPI(api)
        loadNextPage()
    }
    
    func setListHeaderView(_ headerView: UIView?) {
        view.setListHeaderView(headerView)
    }
    
    func removeUser(_ user: User) {
        view.removeUser(user)
    }
}

extension UserListPresenter: UserProfileModuleOutput {
    
    func didChangeUserFollowStatus(_ user: User) {
        view.updateListItem(with: user)
    }
}
