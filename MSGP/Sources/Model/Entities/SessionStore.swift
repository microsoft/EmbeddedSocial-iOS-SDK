//
//  SessionStore.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

final class SessionStore {
    private(set) var user: User!
    private(set) var sessionToken: String!
    
    private let database: SessionStoreDatabase
    
    var isLoggedIn: Bool {
        return user != nil && sessionToken != nil
    }
    
    init(database: SessionStoreDatabase) {
        self.database = database
    }
    
    func createSession(withUser user: User, sessionToken: String) {
        self.user = user
        self.sessionToken = sessionToken
    }
    
    func loadLastSession() throws {
        var user: User?
        var sessionToken: String?
        
        if getEnvironmentVariable("MSGP_MOCK_SERVER") != nil {
            
            let creds = CredentialsList(provider: .facebook,
                                        accessToken: "AccessToken",
                                        requestToken: "RequestToken",
                                        socialUID: UUID().uuidString,
                                        appKey: "AppKey")
            
            user = User(socialUser: SocialUser(uid: UUID().uuidString,
                                               credentials: creds,
                                               firstName: "John",
                                               lastName: "Doe",
                                               email: "jonh.doe@contoso.com",
                                               bio: "Lorem ipsum dolor",
                                               photo: Photo(image:(UIImage(asset: .userPhotoPlaceholder)))),
                            userHandle: "UserHandle")
            
            sessionToken = "SessionToken"
            
        } else {
            
            user = database.loadLastUser()
            sessionToken = database.loadLastSessionToken()
            
            if (user == nil) || (sessionToken == nil) {
                throw Error.lastSessionNotAvailable
            }
            
        }
        
        createSession(withUser: user!, sessionToken: sessionToken!)
    }
    
    func saveCurrentSession() throws {
        guard isLoggedIn else {
            throw Error.notLoggedIn
        }
        
        database.saveUser(user)
        database.saveSessionToken(sessionToken)
    }
}

extension SessionStore {
    enum Error: LocalizedError {
        case notLoggedIn
        case lastSessionNotAvailable

        public var errorDescription: String? {
            switch self {
            case .notLoggedIn: return "User is not logged in."
            case .lastSessionNotAvailable: return "Last session is not available."
            }
        }
    }
}
