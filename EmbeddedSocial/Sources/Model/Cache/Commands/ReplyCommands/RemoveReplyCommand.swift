//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveReplyCommand: ReplyCommand {
    override func setRelatedHandle(_ relatedHandle: String?) {
        reply.commentHandle = relatedHandle
    }
    
    override func getRelatedHandle() -> String? {
        return reply.commentHandle
    }
}
