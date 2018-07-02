//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AcceptPendingCommand: UserCommand {
    
    override func apply(to user: inout User) {
        user.followerStatus = .accepted
    }
}
