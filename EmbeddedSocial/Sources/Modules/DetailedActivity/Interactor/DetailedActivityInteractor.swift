//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol DetailedActivityInteractorOutput: class {
    func loaded(comment: Comment)
    func loaded(reply: Reply)
    func failedLoadComment(error: Error)
    func failedLoadReply(error: Error)
}

protocol DetailedActivityInteractorInput {
    func loadComment()
    func loadReply()
}

class DetailedActivityInteractor: DetailedActivityInteractorInput {

    weak var output: DetailedActivityInteractorOutput!
    
    var commentHandle: String?
    var replyHandle: String?
    
    var replyService: RepliesServiceProtcol
    var commentService: CommentServiceProtocol
    
    init(replyService: RepliesServiceProtcol, commentService: CommentServiceProtocol) {
        self.replyService = replyService
        self.commentService = commentService
    }
    
    func loadComment() {
        commentService.comment(commentHandle: commentHandle!, cachedResult: { (cachedComment) in
            self.output.loaded(comment: cachedComment)
        }, success: { (webComment) in
            self.output.loaded(comment: webComment)
        }) { (error) in
            self.output.failedLoadComment(error: error)
        }
    }
    
    func loadReply() {
        replyService.reply(replyHandle: replyHandle!, cachedResult: { (cachedReply) in
            self.output.loaded(reply: cachedReply)
        }, success: { (webReply) in
            self.output.loaded(reply: webReply)
        }) { (error) in
            self.output.failedLoadReply(error: error)
        }
    }

}
