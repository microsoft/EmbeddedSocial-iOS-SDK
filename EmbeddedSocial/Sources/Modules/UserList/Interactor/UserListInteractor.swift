//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListInteractor: UserListInteractorInput {
    
    weak var output: UserListInteractorOutput?

    private let socialService: SocialServiceType
    private var listProcessor: UsersListProcessorType

    var isLoadingList: Bool {
        return listProcessor.isLoadingList
    }
    
    var listHasMoreItems: Bool {
        return listProcessor.listHasMoreItems
    }
    
    init(api: UsersListAPI,
         socialService: SocialServiceType,
         networkTracker: NetworkStatusMulticast = SocialPlus.shared.networkTracker) {
        
        self.socialService = socialService
        listProcessor = UsersListProcessor(api: api, networkTracker: networkTracker)
        listProcessor.delegate = self
    }
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void) {
        guard let followStatus = user.followerStatus, let visibility = user.visibility else {
            completion(.failure(APIError.missingUserData))
            return
        }
        
        let nextStatus = FollowStatus.reduce(status: followStatus, visibility: visibility)
        
        socialService.changeFollowStatus(user: user) { result in
            if result.isSuccess {
                completion(.success(nextStatus))
            } else {
                completion(.failure(result.error ?? APIError.unknown))
            }
        }
    }
    
    func setAPI(_ api: UsersListAPI) {
        listProcessor.setAPI(api)
    }
    
    func reloadList(completion: @escaping (Result<[User]>) -> Void) {
        listProcessor.reloadList(completion: completion)
    }
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        listProcessor.getNextListPage(completion: completion)
    }
}

extension UserListInteractor: UsersListProcessorDelegate {
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        output?.didUpdateListLoadingState(isLoading)
    }
}
