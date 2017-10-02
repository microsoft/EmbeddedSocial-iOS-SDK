//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol DetailedActivityInteractorOutput: class {
    func loaded(comment: Comment)
    func loaded(reply: Reply)
}

protocol DetailedActivityInteractorInput {
    
}

class DetailedActivityInteractor: DetailedActivityInteractorInput {

    weak var output: DetailedActivityInteractorOutput!
    
    var commentHandle: String?
    var replyHandle: String?
    
    var replyService = RepliesService()
    var commentService = CommentsService(imagesService: ImagesService())
    
    func loadComment() {
        commentService.comment(commentHandle: commentHandle!, cachedResult: { (cachedComment) in
            self.output.loaded(comment: cachedComment)
        }, success: { (webComment) in
            self.output.loaded(comment: webComment)
        }) { (error) in
            
        }
    }
    
    func loadReply() {
        replyService.reply(replyHandle: replyHandle!, cachedResult: { (cachedReply) in
            self.loaded(reply: cachedReply)
        }, success: { (webReply) in
            self.loaded(reply: webReply)
        }) { (error) in
            
        }
    }
    
    private func loaded(comment: Comment) {
        
    }
    
    private func loaded(reply: Reply) {
        
    }

}
