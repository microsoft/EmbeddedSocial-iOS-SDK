//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FollowRequestsInteractor: FollowRequestsInteractorInput {
    
    weak var output: FollowRequestsInteractorOutput?
    
    private let activityService: ActivityService
    private var listProcessor: UsersListProcessorType
    
    var isLoadingList: Bool {
        return listProcessor.isLoadingList
    }
    
    var listHasMoreItems: Bool {
        return listProcessor.listHasMoreItems
    }
    
    init(listProcessor: UsersListProcessorType, activityService: ActivityService) {
        self.activityService = activityService
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
        activityService.acceptPendingRequest(handle: user.uid, completion: completion)
    }
    
    func rejectPendingRequest(to user: User, completion: @escaping (Result<Void>) -> Void) {
        activityService.rejectPendingRequest(handle: user.uid, completion: completion)
    }
}

extension FollowRequestsInteractor: UsersListProcessorDelegate {
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        output?.didUpdateListLoadingState(isLoading)
    }
}
