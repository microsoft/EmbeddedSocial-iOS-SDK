//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostDetailInteractor: PostDetailInteractorInput {

    weak var output: PostDetailInteractorOutput!
    
    var commentsService: CommentsService?
    var likeService: LikesService?
    
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
    
    func postComment(image: UIImage?, topicHandle: String, comment: String) {
        let request = PostCommentRequest()
        request.text = comment
        commentsService?.postComment(topicHandle: topicHandle, comment: request, resultHandler: { (response) in
            let comment = Comment()
            comment.text = request.text
            comment.firstName = SocialPlus.shared.sessionStore.user.firstName
            comment.lastName = SocialPlus.shared.sessionStore.user.lastName
            self.output.commentDidPosted(comment: comment)
        })
    }
    
    func likeComment(commentHandle: String) {
        likeService?.likeComment(commentHandle: commentHandle)
    }
    
    func unlikeComment(commentHandle: String) {
        likeService?.unlikeComment(commentHandle: commentHandle)
    }
}
