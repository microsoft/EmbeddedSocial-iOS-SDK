//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ModelStack {
    let user: User
    let sessionToken: String
    
    init(user: User, sessionToken: String) {
        self.user = user
        self.sessionToken = sessionToken
    }
}
