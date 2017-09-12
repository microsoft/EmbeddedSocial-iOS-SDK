//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class FollowCommand: UserCommand {
    override var oppositeCommand: UserCommand? {
        return user.visibility == ._public ? UnfollowCommand(user: user) : CancelPendingCommand(user: user)
    }
}
