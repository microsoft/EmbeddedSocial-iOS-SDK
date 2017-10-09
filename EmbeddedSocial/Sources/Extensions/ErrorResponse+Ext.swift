//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension ErrorResponse {
    
    var statusCode: Int {
        switch self {
        case let .HttpError(code, _, _): return code
        case .DecodeError: return -1
        }
    }
}
