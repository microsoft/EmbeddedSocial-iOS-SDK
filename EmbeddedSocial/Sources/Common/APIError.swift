//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum APIError: LocalizedError {
    case failedRequest
    case unknown
    case missingUserData
    case cancelled
    case custom(String)
    case imageCompression
    case missingCredentials

    public var errorDescription: String? {
        switch self {
        case .failedRequest: return L10n.Error.failedRequest
        case .unknown: return L10n.Error.unknown
        case .missingUserData: return L10n.Error.missingUserData
        case .cancelled: return L10n.Error.cancelledByUser
        case .imageCompression: return L10n.Error.imageCompressionFailed
        case .missingCredentials: return L10n.Error.missingCredentials
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
