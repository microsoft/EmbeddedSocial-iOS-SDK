//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserProfileInteractorInput {    
    func getUser(userID: String, completion: @escaping (Result<User>) -> Void)
    
    func getMe(credentials: CredentialsList, completion: @escaping (Result<User>) -> Void)
    
    func block(userID: String, completion: @escaping (Result<Void>) -> Void)

    func processSocialRequest(currentFollowStatus: FollowStatus, userID: String, completion: @escaping (Result<Void>) -> Void)
    
    func cachedUser(with handle: String) -> User?
}
