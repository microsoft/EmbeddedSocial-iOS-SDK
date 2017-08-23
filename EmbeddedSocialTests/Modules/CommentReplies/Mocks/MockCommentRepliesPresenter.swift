//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentRepliesPresenter: CommentRepliesPresenter {
    
    var fetchedRepliesCount = 0
    override func fetched(replies: [Reply], cursor: String?) {
        fetchedRepliesCount = replies.count
    }

    var fetchedMoreRepliesCount = 0
    override func fetchedMore(replies: [Reply], cursor: String?) {
        fetchedMoreRepliesCount = replies.count
    }
    
    var postedReply: Reply?
    override func replyPosted(reply: Reply) {
        postedReply = reply
    }
    
    override func didPostAction(replyHandle: String, action: RepliesSocialAction, error: Error?) {
        guard let index = replies.enumerated().first(where: { $0.element.replyHandle == replyHandle })?.offset else {
            return
        }
        
        switch action {
        case .like:
            replies[index].totalLikes += 1
            replies[index].liked = true
        case .unlike:
            replies[index].totalLikes -= 1
            replies[index].liked = false
        }
    }
    
}
