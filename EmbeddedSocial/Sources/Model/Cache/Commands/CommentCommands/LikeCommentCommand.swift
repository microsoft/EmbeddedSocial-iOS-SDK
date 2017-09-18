//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class LikeCommentCommand: CommentCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return UnlikeCommentCommand(commentHandle: commentHandle)
    }
    
    override func apply(to comment: inout Comment) {
        comment.liked = true
        comment.totalLikes += 1
    }
}
