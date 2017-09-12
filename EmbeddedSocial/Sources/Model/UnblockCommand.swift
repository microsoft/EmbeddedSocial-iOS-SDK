//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UnblockCommand: UserCommand {
    override var oppositeCommand: UserCommand? {
        return BlockCommand(user: user)
    }
}
