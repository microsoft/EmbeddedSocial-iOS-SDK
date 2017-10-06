//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListInteractor: UserListInteractorInput {
    
    weak var output: UserListInteractorOutput?

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

extension UserListInteractor: PaginatedListProcessorDelegate {
    
    func didUpdateListLoadingState(_ isLoading: Bool) {
        output?.didUpdateListLoadingState(isLoading)
    }
}
