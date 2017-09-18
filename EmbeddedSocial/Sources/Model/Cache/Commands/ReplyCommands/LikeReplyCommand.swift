//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LikeReplyCommand: ReplyCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return UnlikeReplyCommand(replyHandle: replyHandle)
    }
    
    override func apply(to reply: inout Reply) {
        reply.liked = true
        reply.totalLikes += 1
    }
}
