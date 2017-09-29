//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LinkedAccountsInteractor: LinkedAccountsInteractorInput {
    
    private let usersService: UserServiceType
    
    init(usersService: UserServiceType) {
        self.usersService = usersService
    }
    
    func getLinkedAccounts(completion: @escaping (Result<[LinkedAccountView]>) -> Void) {
        usersService.getLinkedAccounts(completion: completion)
    }
}
