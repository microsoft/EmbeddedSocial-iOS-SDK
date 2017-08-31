//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListInteractorInput {
    var isLoadingList: Bool { get }
    
    var listHasMoreItems: Bool { get }
    
    func getNextListPage(completion: @escaping (Result<[User]>) -> Void)
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void)
    
    func setAPI(_ api: UsersListAPI)
}

protocol UserListInteractorOutput: class {
    func didUpdateListLoadingState(_ isLoading: Bool)
}
