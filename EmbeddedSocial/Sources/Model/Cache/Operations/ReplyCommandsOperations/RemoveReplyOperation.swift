//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveReplyOperation: OutgoingCommandOperation {
    let repliesService: RepliesServiceProtcol
    let command: ReplyCommand
    
    required init(command: ReplyCommand, repliesService: RepliesServiceProtcol) {
        self.command = command
        self.repliesService = repliesService
    }
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        repliesService.delete(reply: command.reply) { (result) in
            self.completeOperation(with: result.error)
        }
    }
}
