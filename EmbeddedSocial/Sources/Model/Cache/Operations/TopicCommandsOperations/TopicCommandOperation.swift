//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class TopicCommandOperation: OutgoingCommandOperation {
    let command: TopicCommand
    
    init(command: TopicCommand) {
        self.command = command
        super.init()
    }
}
