//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockUserListInteractor: UserListInteractorInput {
    
    var isLoadingList: Bool = false
    
    var listHasMoreItems: Bool = false
    
    private(set) var processSocialRequestCount = 0
    var socialRequestResult: Result<FollowStatus>?
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void) {
        processSocialRequestCount += 1
        if let result = socialRequestResult {
            completion(result)
        }
    }
    
    private(set) var setAPICount = 0
    private(set) var api: UsersListAPI?

    func setAPI(_ api: UsersListAPI) {
        setAPICount += 1
        self.api = api
    }
    
    private(set) var getNextListPageCount = 0
    var getNextListPageReturnValue: Result<[User]>?

    func getNextListPage(completion: @escaping (Result<[User]>) -> Void) {
        getNextListPageCount += 1
        if let result = getNextListPageReturnValue {
            completion(result)
        }
    }
}
