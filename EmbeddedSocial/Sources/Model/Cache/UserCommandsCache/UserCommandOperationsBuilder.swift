//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol UserCommandOperationsBuilderType {
    static func operation(for command: UserCommand) -> Operation?
}

struct UserCommandOperationsBuilder: UserCommandOperationsBuilderType {
    
    static func operation(for command: UserCommand) -> Operation? {
        if command is FollowCommand {
            return FollowOperation(command: command, socialService: SocialService())
        } else if command is UnfollowCommand {
            return UnfollowOperation(command: command, socialService: SocialService())
        } else if command is BlockCommand {
            return BlockOperation(command: command, socialService: SocialService())
        } else if command is UnblockCommand {
            return UnblockOperation(command: command, socialService: SocialService())
        } else if command is CancelPendingCommand {
            return CancelPendingOperation(command: command, socialService: SocialService())
        }

        return nil
    }
}
