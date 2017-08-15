//
//  CommentRepliesCommentRepliesInteractor.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 14/08/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CommentRepliesInteractor: CommentRepliesInteractorInput {

    weak var output: CommentRepliesInteractorOutput!
    
    private var cursor: String?
    private let limit = 10
    private var isLoading = false
    var repliesService: RepliesServiceProtcol?

    func fetchReplies(commentHandle: String) {
        isLoading = true
        repliesService?.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: limit) { (result) in
            guard result.error == nil else {
                return
            }
            
            self.isLoading = false
            self.cursor = result.cursor
            self.output.fetched(replies: result.replies)
        }
    }
    
    func fetchMoreReplies(commentHandle: String) {
        if cursor == "" || cursor == nil || isLoading == true {
            return
        }
        
        isLoading = true
        repliesService?.fetchReplies(commentHandle: commentHandle, cursor: cursor, limit: limit, resultHandler: { (result) in
            guard result.error == nil else {
                return
            }
            
            if self.cursor == nil {
                return
            }
            
            self.isLoading = false
            self.cursor = result.cursor
            self.output.fetchedMore(replies: result.replies)
        })
        
    }
    
    func postReply(commentHandle: String, text: String) {
        let request = PostReplyRequest()
        request.text = text
        
        repliesService?.postReply(commentHandle: commentHandle, request: request)
    }

    
}
