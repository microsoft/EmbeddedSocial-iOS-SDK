//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
                completion(.failure(APIError(error: error as? ErrorResponse)))
            }
        }
    }
}
