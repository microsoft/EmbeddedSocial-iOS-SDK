//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum APIError: LocalizedError {
    case failedRequest
    case unknown
    case missingUserData
    case responseError(String)
    case cancelled
    case custom(String)

    public var errorDescription: String? {
        switch self {
        case .failedRequest: return "The request has failed."
        case .unknown: return "Unknown error occurred."
        case .missingUserData: return "User data is missing."
        case let .responseError(path): return "Response \(path) returned with error."
        case .cancelled: return "The operation has been cancelled by user."
        case let .custom(text): return text
        }
    }
    
    init(error: ErrorResponse?) {
        guard let error = error,
            case let ErrorResponse.HttpError(_, data, _) = error,
            data != nil,
            let someObject = try? JSONSerialization.jsonObject(with: data!, options: []),
            let json = someObject as? [String: Any],
            let message = json["message"] as? String else {
                self = .unknown
                return
        }
        self = .custom(message)
    }
}
