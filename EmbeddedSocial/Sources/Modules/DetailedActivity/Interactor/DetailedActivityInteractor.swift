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
    
    var replyService: RepliesServiceProtcol = RepliesService()
    var commentService: CommentServiceProtocol = CommentsService(imagesService: ImagesService())
    
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
