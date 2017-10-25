//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
import Alamofire
import MBProgressHUD

struct GlobalApiErrorHandler: APIErrorHandler {
    
    let unauthorizedErrorHandler: UnauthorizedErrorHandler
    weak var navigationController: UINavigationController?
    
    init(unauthorizedErrorHandler: UnauthorizedErrorHandler, navigationController: UINavigationController? = SocialPlus.shared.coordinator.navigationStack.navigationController) {
        self.unauthorizedErrorHandler = unauthorizedErrorHandler
        self.navigationController = navigationController
    }
    
    func canHandle(_ error: Error?) -> Bool {
        if let _ = error as? StatusCodeble {
            return true
        }
        
        return false
    }
    
    func handle(_ error: Error?) {
        guard let statusCode = (error as? StatusCodeble)?.httpStatusCode() else {
            return
        }
        
        guard let errorText = APIError(error: error as? ErrorResponse).errorDescription else {
            return
        }
        
        switch statusCode  {
        case Constants.HTTPStatusCodes.Unauthorized.rawValue:
            if unauthorizedErrorHandler.canHandle(error) {
                unauthorizedErrorHandler.handle(error)
            }
        case Constants.HTTPStatusCodes.BadRequest.rawValue, Constants.HTTPStatusCodes.PaymentRequired.rawValue...Constants.HTTPStatusCodes.UnavailableForLegalReasons.rawValue:
            navigationController?.viewControllers.last?.hideHUD()
            let alertController = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            navigationController?.present(alertController, animated: true, completion: nil)
        default:
            print("handle if needed")
            //handle if needed
        }
    }
    
}

protocol StatusCodeble {
    func httpStatusCode() -> Int?
}

extension AFError: StatusCodeble {
    func httpStatusCode() -> Int? {
        return responseCode
    }
}

extension ErrorResponse: StatusCodeble {
    func httpStatusCode() -> Int? {
        return statusCode
    }
}
