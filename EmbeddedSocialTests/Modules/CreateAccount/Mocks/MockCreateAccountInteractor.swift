//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

final class MockCreateAccountInteractor: CreateAccountInteractorInput {
    private(set) var createAccountCount = 0
    private(set) var lastSocialUser: SocialUser?
    
    var resultMaker: (SocialUser) -> Result<(user: User, sessionToken: String)> = {
        return .success(User(socialUser: $0, userHandle: ""), "")
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        createAccountCount += 1
        lastSocialUser = user
        completion(resultMaker(user))
    }
}
