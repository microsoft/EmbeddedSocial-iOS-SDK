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
    
    func apply(to feed: inout CommentFetchResult) {
        var comments = feed.comments
        
        for (index, comment) in comments.enumerated() {
            if comment.commentHandle == reply.commentHandle {
                comment.totalReplies += 1
                comments[index] = comment
            }
        }
        
        feed.comments = comments
    }
    
    override func apply(to feed: inout RepliesFetchResult) {
        var replies = feed.replies
        replies.insert(reply, at: 0)
        feed.replies = replies
    }
}
