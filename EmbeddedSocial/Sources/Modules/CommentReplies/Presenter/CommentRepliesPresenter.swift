//
//  CommentRepliesCommentRepliesPresenter.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CommentRepliesPresenter: CommentRepliesModuleInput, CommentRepliesViewOutput, CommentRepliesInteractorOutput {


    weak var view: CommentRepliesViewInput!
    var interactor: CommentRepliesInteractorInput!
    var router: CommentRepliesRouterInput!
    
    var commentView: CommentViewModel?
    
    var replies = [Reply]()

    func fetchedMore(replies: [Reply]) {
        self.replies.append(contentsOf: replies)
        view.reloadTable()
    }
    
    func replyPosted(reply: Reply) {
        replies.append(reply)
        view.reloadReplies()
    }
    
    func replyFailPost(error: Error) {
        
    }
    
    func viewIsReady() {
        interactor.fetchReplies(commentHandle: (commentView?.commentHandle)!)
    }
    
    func mainComment() -> CommentViewModel {
        return commentView!
    }
    
    func numberOfItems() -> Int {
        return replies.count
    }
    
    func postReply(text: String) {
        interactor.postReply(commentHandle: (commentView?.commentHandle)!, text: text)
    }
    
    func fetched(replies: [Reply]) {
        self.replies = replies
        view.reloadTable()
    }
}
