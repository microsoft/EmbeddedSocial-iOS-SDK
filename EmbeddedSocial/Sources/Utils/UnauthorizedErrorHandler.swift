//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol LogoutController {
    func logOut()
    
    func logOut(with error: Error)
}

struct UnauthorizedErrorHandler: APIErrorHandler {
    private let logoutController: LogoutController
    private let sessionService: SessionServiceType
    
    init(logoutController: LogoutController = SocialPlus.shared, sessionService: SessionServiceType = SessionService()) {
        self.logoutController = logoutController
        self.sessionService = sessionService
    }
    
    func canHandle(_ error: Error?) -> Bool {
        return (error as? ErrorResponse)?.statusCode == Constants.API.unauthorizedStatusCode
    }
    
    func handle(_ error: Error?) {
        logoutController.logOut(with: APIError(error: error as? ErrorResponse))
    }
}
