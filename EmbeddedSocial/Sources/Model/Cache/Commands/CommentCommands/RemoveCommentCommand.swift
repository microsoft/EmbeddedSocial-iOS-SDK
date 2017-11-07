//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class RemoveCommentCommand: CommentCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return CreateCommentCommand(comment: comment)
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        comment.topicHandle = relatedHandle
    }
    
    override func getRelatedHandle() -> String? {
        return comment.topicHandle
    }
}
