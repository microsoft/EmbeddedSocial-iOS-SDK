//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockSessionStoreRepositoryProvider: SessionStoreRepositoryProviderType {
    let userRepository: AbstractKeyValueRepository<User>
    let sessionTokenRepository: AbstractKeyValueRepository<String>
    
    init(userRepository: AbstractKeyValueRepository<User>, sessionTokenRepository: AbstractKeyValueRepository<String>) {
        self.userRepository = userRepository
        self.sessionTokenRepository = sessionTokenRepository
    }
    
    func getUserRepository() -> AbstractKeyValueRepository<User> {
        return userRepository
    }
    
    func getSessionTokenRepository() -> AbstractKeyValueRepository<String> {
        return sessionTokenRepository
    }
}

