//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserListInteractorInput {
    func getUsers(completion: @escaping (Result<[User]>) -> Void)
    
    func processSocialRequest(to user: User, completion: @escaping (Result<FollowStatus>) -> Void)
}
