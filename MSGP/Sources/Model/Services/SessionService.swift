//
//  SessionService.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/19/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

protocol SessionServiceType {
    func makeNewSession(with credentials: CredentialsList, userUID: String, completion: @escaping (Result<String>) -> Void)
}

struct SessionService: SessionServiceType {
    private let apiSettings: APISettings
    
    init(apiSettings: APISettings = APISettings.shared) {
        self.apiSettings = apiSettings
    }
    
    func makeNewSession(with credentials: CredentialsList, userUID: String, completion: @escaping (Result<String>) -> Void) {
        apiSettings.customHeaders = credentials.authHeader
        
        let request = PostSessionRequest()
        request.instanceId = UUID().uuidString
        request.userHandle = userUID
        
        SessionsAPI.sessionsPostSession(request: request) { response, error in
            if let sessionToken = response?.sessionToken {
                completion(.success(sessionToken))
            } else {
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }
}
