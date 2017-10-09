//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SessionStoreDatabase {
    func saveUser(_ user: User)
    
    func loadLastUser() -> User?
    
    func saveSessionToken(_ token: String)
    
    func loadLastSessionToken() -> String?
    
    func cleanup()
}
