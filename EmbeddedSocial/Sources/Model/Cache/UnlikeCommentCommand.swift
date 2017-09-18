//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class UnlikeCommentCommand: CommentCommand {
    
    override var inverseCommand: OutgoingCommand? {
        return LikeCommentCommand(commentHandle: commentHandle)
    }
    
    override func apply(to comment: inout Comment) {
        comment.liked = true
        comment.totalLikes = max(0, comment.totalLikes - 1)
    }
}
