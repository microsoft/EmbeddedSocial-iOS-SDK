//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

class MockCommentRepliesIneractor: CommentRepliesInteractorInput {
    
    weak var output: CommentRepliesInteractorOutput!
    
    func fetchReplies(commentHandle: String, cursor: String?, limit: Int) {
        output.fetched(replies: [Reply()], cursor: cursor)
    }
    
    func fetchMoreReplies(commentHandle: String, cursor: String?, limit: Int) {
        output.fetchedMore(replies: [Reply()], cursor: cursor)
    }
    
    func replyAction(replyHandle: String, action: RepliesSocialAction) {
        output.didPostAction(replyHandle: replyHandle, action: action, error: nil)
    }
    
    func postReply(commentHandle: String, text: String) {
        let reply = Reply()
        output.replyPosted(reply: reply)
    }
}
