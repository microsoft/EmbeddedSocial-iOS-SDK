//
//  CommentRepliesCommentRepliesInteractor.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CommentRepliesInteractor: CommentRepliesInteractorInput {

    weak var output: CommentRepliesInteractorOutput!
    
    private var cursor = ""
    private let limit = 10
    private var isLoading = false
    var repliesService: RepliesServiceProtcol?

    func fetchReplies(commentHandle: String) {
        isLoading = true
        repliesService?.fetchComments(commentHandle: commentHandle, cursor: cursor, limit: limit) { (result) in
            guard result.error == nil else {
                return
            }
            
            self.isLoading = false
            self.cursor = result.cursor!
            self.output.fetched(replies: result.replies)
        }
    }

    
}
