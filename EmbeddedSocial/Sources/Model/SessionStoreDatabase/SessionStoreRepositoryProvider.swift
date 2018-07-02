//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SessionStoreRepositoryProviderType {
    func getUserRepository() -> AbstractKeyValueRepository<User>
    
    func getSessionTokenRepository() -> AbstractKeyValueRepository<String>
}

struct SessionStoreRepositoryProvider: SessionStoreRepositoryProviderType {
    
    func getUserRepository() -> AbstractKeyValueRepository<User> {
        return KeyValueRepository(storage: UserDefaults.standard)
    }
    
    func getSessionTokenRepository() -> AbstractKeyValueRepository<String> {
        return KeyValueRepository(storage: UserDefaults.standard)
    }
}
