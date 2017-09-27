//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct SessionInfo {
    let user: User
    let token: String
    let source: Source
}

extension SessionInfo {
    enum Source {
        case modal
        case menu
    }
}
