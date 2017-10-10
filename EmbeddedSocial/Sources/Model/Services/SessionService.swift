//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol SessionServiceType {
    func makeNewSession(with credentials: CredentialsList, userID: String, completion: @escaping (Result<String>) -> Void)
    
    func requestToken(authProvider: AuthProvider, completion: @escaping (Result<String>) -> Void)
    
    func deleteCurrentSession(completion: @escaping (Result<Void>) -> Void)
}

class SessionService: BaseService, SessionServiceType {
    
    private let appKey: String
    
    init(appKey: String = SocialPlus.settings.appKey) {
        self.appKey = appKey
        super.init()
    }
    
    func makeNewSession(with credentials: CredentialsList, userID: String, completion: @escaping (Result<String>) -> Void) {
        let request = PostSessionRequest()
        request.instanceId = UUID().uuidString
        request.userHandle = userID
        
        SessionsAPI.sessionsPostSession(request: request, authorization: credentials.authorization) { response, error in
            if let sessionToken = response?.sessionToken {
                completion(.success(sessionToken))
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
    
    func requestToken(authProvider: AuthProvider, completion: @escaping (Result<String>) -> Void) {
        let provider = authProvider.sessionServiceIdentityProvider
        SessionsAPI.requestTokensGetRequestToken(
            identityProvider: provider,
            authorization: Authorization.anonymous(appKey: appKey)) { response, error in
                if let token = response?.requestToken {
                    completion(.success(token))
                } else {
                    self.errorHandler.handle(error: error, completion: completion)
                }
        }
    }
    
    func deleteCurrentSession(completion: @escaping (Result<Void>) -> Void) {
        SessionsAPI.sessionsDeleteSession(authorization: authorization) { response, error in
            if error == nil {
                completion(.success())
            } else {
                self.errorHandler.handle(error: error, completion: completion)
            }
        }
    }
}
