//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnlikeReplyOperation: ReplyCommandOperation {
    
    override func main() {
        guard !isCancelled else {
            return
        }
        
        likesService.unlikeReply(replyHandle: command.reply.replyHandle) { [weak self] _, _ in
            self?.completeIfNotCancelled()
        }
    }
}
