//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class CreateReplyCommand: ReplyCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return RemoveReplyCommand(reply: reply)
    }
    
    override func getRelatedHandle() -> String? {
        return reply.commentHandle
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        reply.commentHandle = relatedHandle
    }
}
