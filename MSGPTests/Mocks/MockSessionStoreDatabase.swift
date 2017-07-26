//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockSessionStoreDatabase: SessionStoreDatabase {
    private(set) var saveUserCount = 0
    private(set) var loadUserCount = 0
    private(set) var saveSessionTokenCount = 0
    private(set) var loadSessionTokenCount = 0
    
    var userToReturn: User?
    
    var sessionTokenToReturn: String?

    func saveUser(_ user: User) {
        saveUserCount += 1
    }
    
    func loadLastUser() -> User? {
        loadUserCount += 1
        return userToReturn
    }
    
    func saveSessionToken(_ token: String) {
        saveSessionTokenCount += 1
    }
    
    func loadLastSessionToken() -> String? {
        loadSessionTokenCount += 1
        return sessionTokenToReturn
    }
}
