//
//  DatabaseFacadeServicesProvider.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/20/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol DatabaseFacadeServicesProviderType {
    func getUserRepository() -> AbstractKeyValueRepository<User>
    
    func getSessionTokenRepository() -> AbstractKeyValueRepository<String>
}

struct DatabaseFacadeServicesProvider: DatabaseFacadeServicesProviderType {
    
    func getUserRepository() -> AbstractKeyValueRepository<User> {
        return KeyValueRepository(storage: UserDefaults.standard)
    }
    
    func getSessionTokenRepository() -> AbstractKeyValueRepository<String> {
        return KeyValueRepository(storage: UserDefaults.standard)
    }
}
