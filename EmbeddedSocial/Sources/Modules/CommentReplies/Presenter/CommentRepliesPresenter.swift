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
    
    var comment: Comment?
    
    var replies = [Reply]()

    func fetchedMore(replies: [Reply]) {
        self.replies.append(contentsOf: replies)
        view.reloadTable()
    }
    
    func viewIsReady() {
        interactor.fetchReplies(commentHandle: (comment?.commentHandle)!)
    }
    
    func mainComment() -> Comment {
        return comment!
    }
    
    func numberOfItems() -> Int {
        return replies.count
    }
    
    func fetched(replies: [Reply]) {
        self.replies = replies
        view.reloadTable()
    }
}
