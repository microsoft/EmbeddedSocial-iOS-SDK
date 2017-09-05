//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire

protocol LogoutController {
    func logOut()
    
    func logOut(with error: Error)
}

struct UnauthorizedErrorHandler: APIErrorHandler {
    private let logoutController: LogoutController

    init(logoutController: LogoutController = SocialPlus.shared) {
        self.logoutController = logoutController
    }
    
    func canHandle(_ error: Error?) -> Bool {
        guard !canHandle(error as? AFError) else { return true }
        guard !canHandle(error as? ErrorResponse) else { return true }
        return false
    }
    
    private func canHandle(_ error: AFError?) -> Bool {
        return error?.responseCode == Constants.API.unauthorizedStatusCode
    }
    
    private func canHandle(_ error: ErrorResponse?) -> Bool {
        return error?.statusCode == Constants.API.unauthorizedStatusCode
    }
    
    func handle(_ error: Error?) {
        logoutController.logOut(with: APIError(error: error as? ErrorResponse))
    }
}
