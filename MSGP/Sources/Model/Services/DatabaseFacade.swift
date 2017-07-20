//
//  DatabaseFacade.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

struct DatabaseFacade {
    private let userRepository: AbstractKeyValueRepository<User>
    private let sessionTokenRepository: AbstractKeyValueRepository<String>

    init(services: DatabaseFacadeServicesProviderType) {
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

fileprivate extension DatabaseFacade {
    struct Keys {
        static let lastUser = "last-user"
        static let sessionToken = "session-token"
    }
}
