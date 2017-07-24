//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import MSGP

final class MockSessionStoreDatabase: SessionStoreDatabase {
    private(set) var saveUserCount = 0
    private(set) var loadUserCount = 0
    private(set) var saveSessionCount = 0
    private(set) var loadSessionCount = 0

    func saveUser(_ user: User) {
        saveUserCount += 1
    }
    
    func loadLastUser() -> User? {
        loadUserCount += 1
        return nil
    }
    
    func saveSessionToken(_ token: String) {
        saveSessionCount += 1
    }
    
    func loadLastSessionToken() -> String? {
        loadSessionCount += 1
        return nil
    }
}
