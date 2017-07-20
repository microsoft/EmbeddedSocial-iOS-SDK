//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

final class CreateAccountInteractor: CreateAccountInteractorInput {
    private let userService: UserServiceType

    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func createAccount(for user: SocialUser, completion: @escaping (Result<(user: User, sessionToken: String)>) -> Void) {
        userService.createAccount(for: user, completion: completion)
    }
}
