//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockCreateAccountInteractor: CreateAccountInteractorInput {
    private(set) var createAccountCount = 0
    private(set) var lastUser: User?
    
    var resultMaker: (User) -> Result<(user: User, sessionToken: String)> = {
        return .success($0, "")
    }
    
    func createAccount(for user: User, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        createAccountCount += 1
        lastUser = user
        completion(resultMaker(user))
    }
}
