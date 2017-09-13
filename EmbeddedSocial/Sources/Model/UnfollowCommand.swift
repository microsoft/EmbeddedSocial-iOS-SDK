//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UnfollowCommand: UserCommand {
    override var inverseCommand: UserCommand? {
        return FollowCommand(user: user)
    }
}
