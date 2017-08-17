//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class SessionStore {
    private(set) var user: User?
    private(set) var sessionToken: String?
    
    private let database: SessionStoreDatabase
    
    var isLoggedIn: Bool {
        return user != nil && sessionToken != nil
    }
    
    var authorization: Authorization {
        guard isLoggedIn else {
            return Constants.anonymousAuthorization
        }
        return user?.credentials?.authorization ?? Constants.anonymousAuthorization
    }
    
    init(database: SessionStoreDatabase) {
        self.database = database
    }
    
    func createSession(withUser user: User, sessionToken: String) {
        self.user = user
        self.sessionToken = sessionToken
    }
    
    func updateSession(withUser user: User) {
        self.user = user
    }
    
    func loadLastSession() throws {
        guard let user = UITestsHelper.isRunningTests ? UITestsHelper.mockUser : database.loadLastUser(),
            let sessionToken = UITestsHelper.isRunningTests ? UITestsHelper.mockSessionToken : database.loadLastSessionToken() else {
                throw Error.lastSessionNotAvailable
        }
        
        createSession(withUser: user, sessionToken: sessionToken)
    }
    
    func saveCurrentSession() throws {
        guard isLoggedIn else {
            throw Error.notLoggedIn
        }
        
        database.saveUser(user!)
        database.saveSessionToken(sessionToken!)
    }
    
    func deleteCurrentSession() throws {
        guard isLoggedIn else {
            throw Error.notLoggedIn
        }
        database.cleanup()
    }
}

extension SessionStore {
    enum Error: LocalizedError {
        case notLoggedIn
        case lastSessionNotAvailable

        var errorDescription: String? {
            switch self {
            case .notLoggedIn: return L10n.Error.userNotLoggedIn
            case .lastSessionNotAvailable: return L10n.Error.lastSessionNotAvailable
            }
        }
    }
}
