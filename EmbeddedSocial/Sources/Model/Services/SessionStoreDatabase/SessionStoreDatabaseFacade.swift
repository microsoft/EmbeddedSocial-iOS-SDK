//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SessionStoreDatabaseFacade: SessionStoreDatabase {
    private let userRepository: AbstractKeyValueRepository<User>
    private let sessionTokenRepository: AbstractKeyValueRepository<String>
    
    init(services: SessionStoreRepositoryProviderType) {
        userRepository = services.getUserRepository()
        sessionTokenRepository = services.getSessionTokenRepository()
    }
    
    func saveUser(_ user: User) {
        userRepository.save(user, forKey: Keys.lastUser)
    }
    
    func loadLastUser() -> User? {
        return userRepository.deserialize(forKey: Keys.lastUser)
    }
    
    func saveSessionToken(_ token: String) {
        sessionTokenRepository.save(token, forKey: Keys.sessionToken)
    }
    
    func loadLastSessionToken() -> String? {
        return sessionTokenRepository.deserialize(forKey: Keys.sessionToken)
    }
}

fileprivate extension SessionStoreDatabaseFacade {
    struct Keys {
        static let lastUser = "last-user"
        static let sessionToken = "session-token"
    }
}
