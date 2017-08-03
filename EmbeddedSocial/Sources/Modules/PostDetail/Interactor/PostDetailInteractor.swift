//
//  PostDetailPostDetailInteractor.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 31/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class PostDetailInteractor: PostDetailInteractorInput {

    weak var output: PostDetailInteractorOutput!
    
    var commentsService: CommentsService? = nil
    
    private var cursor: String?
    private let limit: Int32 = 10
    
    func fetchComments(topicHandle: String) {
        commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, resultHandler: { (result) in
            guard result.error == nil else {
                return
            }

            self.cursor = result.cursor
            self.output.didFetch(comments: result.comments.reversed())
        })
    }
}
