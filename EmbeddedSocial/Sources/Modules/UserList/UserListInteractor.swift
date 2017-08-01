//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserListInteractor: UserListInteractorInput {
    private let api: UsersListAPI
    
    init(api: UsersListAPI) {
        self.api = api
    }
    
    func getUsers(completion: @escaping (Result<[User]>) -> Void) {
        api.getUsersList(completion: completion)
    }
}
