//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

final class EditProfileInteractor: EditProfileInteractorInput {
    private let userService: UserServiceType

    init(userService: UserServiceType) {
        self.userService = userService
    }
    
    func editProfile(me: User, completion: @escaping (Result<User>) -> Void) {
        userService.updateProfile(me: me, completion: completion)
    }
}
