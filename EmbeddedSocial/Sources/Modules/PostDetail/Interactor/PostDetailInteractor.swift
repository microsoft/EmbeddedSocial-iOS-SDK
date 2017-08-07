//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
