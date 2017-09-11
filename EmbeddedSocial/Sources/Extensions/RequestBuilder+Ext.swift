//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension RequestBuilder {
    
    var httpMethod: OutgoingAction.HTTPMethod? {
        return OutgoingAction.HTTPMethod(rawValue: method)
    }
}
