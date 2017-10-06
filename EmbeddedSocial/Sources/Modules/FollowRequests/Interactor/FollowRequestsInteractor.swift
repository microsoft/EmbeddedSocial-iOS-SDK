//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FollowRequestsInteractor: FollowRequestsInteractorInput {
    
    weak var output: FollowRequestsInteractorOutput?
    
    private let socialService: SocialServiceType
    private var listProcessor: AbstractPaginatedListProcessor<User>
    
    var isLoadingList: Bool {
        return listProcessor.isLoadingList
    }
    
    var listHasMoreItems: Bool {
        return listProcessor.listHasMoreItems
    }
    
    init(listProcessor: AbstractPaginatedListProcessor<User>, socialService: SocialServiceType) {
        self.socialService = socialService
        self.listProcessor = listProcessor
        self.listProcessor.delegate = self
    }
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void) {
        listProcessor.reloadList(completion: completion)
    }
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        listProcessor.getNextListPage(completion: completion)
    }
    
    func acceptPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void) {
        socialService.acceptPending(user: user, completion: completion)
    }
    
    func rejectPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void) {
        socialService.cancelPending(user: user, completion: completion)
    }
}

extension FollowRequestsInteractor: PaginatedListProcessorDelegate {
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        output?.didUpdateListLoadingState(isLoading)
    }
}
