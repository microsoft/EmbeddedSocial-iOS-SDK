//
//  ModelStack.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/18/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class ModelStack {
    private(set) var user: User! {
        didSet {
            database.saveUser(user)
        }
    }
    
    private(set) var sessionToken: String! {
        didSet {
            database.saveSessionToken(sessionToken)
        }
    }
    
    var isLoggedIn: Bool {
        return user != nil && sessionToken != nil
    }
    
    private let database: DatabaseFacade
    
    init(databaseFacade: DatabaseFacade) {
        self.database = databaseFacade
        user = databaseFacade.loadLastUser()
        sessionToken = databaseFacade.loadLastSessionToken()
    }
    
    func createSession(withUser user: User, sessionToken: String) {
        self.user = user
        self.sessionToken = sessionToken
    }
}
