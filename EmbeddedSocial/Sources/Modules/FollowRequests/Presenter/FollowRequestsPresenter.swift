//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class FollowRequestsPresenter: FollowRequestsViewOutput {
    weak var view: FollowRequestsViewInput!
    var interactor: FollowRequestsInteractorInput!
    var router: FollowRequestsRouterInput!
    weak var output: FollowRequestsModuleOutput?
    
    fileprivate var isAnimatingPullToRefresh = false
    
    private let noDataText: NSAttributedString?
    
    init(noDataText: NSAttributedString?) {
        self.noDataText = noDataText
    }
    
    func viewIsReady() {
        view.setupInitialState()
        view.setNoDataText(noDataText)
        loadNextPage()
    }
    
    func loadNextPage() {
        view.setIsEmpty(false)
        
        interactor.getNextListPage { [weak self] result in
            self?.processUsersResult(result)
        }
    }
    
    fileprivate func processUsersResult(_ result: Result<[User]>) {
        if let users = result.value {
            view.setUsers(users)
        } else {
            view.showError(result.error ?? APIError.unknown)
        }
        
        view.setIsEmpty(result.value?.isEmpty ?? true)
    }
    
    func onReachingEndOfPage() {
        guard !interactor.isLoadingList, interactor.listHasMoreItems else {
            return
        }
        loadNextPage()
    }
    
    func onItemSelected(_ item: FollowRequestItem) {
        // ask if need to open Profile module
    }
    
    func onAccept(_ item: FollowRequestItem) {
        view.setIsLoading(true, item: item)
        interactor.acceptPendingRequest(to: item.user) { [weak self] result in
            self?.processPendingRequestResult(result, item: item)
            if result.isSuccess {
                self?.output?.didAcceptFollowRequest()
            }
        }
    }
    
    func onReject(_ item: FollowRequestItem) {
        view.setIsLoading(true, item: item)
        interactor.rejectPendingRequest(to: item.user) { [weak self] result in
            self?.processPendingRequestResult(result, item: item)
        }
    }
    
    private func processPendingRequestResult(_ result: Result<Void>, item: FollowRequestItem) {
        view.setIsLoading(false, item: item)

        guard result.isSuccess else {
            view.showError(result.error ?? APIError.unknown)
            return
        }
        
        view.removeUser(item.user)
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

extension FollowRequestsPresenter: FollowRequestsInteractorOutput {
    func didUpdateListLoadingState(_ isLoading: Bool) {
        guard !isAnimatingPullToRefresh else { return }
        view.setIsLoading(isLoading)
    }
}
