//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentRepliesIneractor: CommentRepliesInteractorInput {
    
    weak var output: CommentRepliesInteractorOutput!
    
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int) {
        let reply = Reply()
        reply.replyHandle = "handle"
        reply.createdTime = Date()
        output.fetched(replies: [reply], cursor: cursor)
    }
    
    func fetchMoreReplies(commentHandle: String, cursor: String?, limit: Int) {
        let reply = Reply()
        reply.replyHandle = "handle more"
        reply.createdTime = Date()
        
        if cursor != nil {
             output.fetchedMore(replies: [], cursor: nil)
        } else {
            output.fetchedMore(replies: [reply], cursor: "cursor")
        }

    }
    
    func replyAction(replyHandle: String, action: RepliesSocialAction) {
        output.didPostAction(replyHandle: replyHandle, action: action, error: nil)
    }
    
    func postReply(commentHandle: String, text: String) {
        let reply = Reply()
        reply.replyHandle = "created handle"
        reply.createdTime = Date()
        output.replyPosted(reply: reply)
    }
}
