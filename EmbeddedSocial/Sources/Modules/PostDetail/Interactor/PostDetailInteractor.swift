//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum CommentSocialAction: Int {
    case like, unlike
}

class PostDetailInteractor: PostDetailInteractorInput {

    weak var output: PostDetailInteractorOutput!
    
    var commentsService: CommentServiceProtocol?
    var likeService: LikesServiceProtocol?
    var isLoading = false
    
    
    private var cursor: String?
    private let limit: Int32 = 10
    
    
    // MARK: Social Actions
    
    func commentAction(commentHandle: String, action: CommentSocialAction) {
        
        let completion: LikesServiceProtocol.CompletionHandler = { [weak self] (handle, err) in
            //            self?.output.didPostAction(post: post, action: action, error: err)
        }
        
        switch action {
        case .like:
            likeService?.likeComment(commentHandle: commentHandle, completion: completion)
        case .unlike:
            likeService?.unlikeComment(commentHandle: commentHandle, completion: completion)
        }
        
    }
    
    func fetchComments(topicHandle: String) {
        isLoading = true
        commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, resultHandler: { (result) in
            guard result.error == nil else {
                return
            }

            self.isLoading = false
            self.cursor = result.cursor
            self.output.didFetch(comments: result.comments)
        })
    }
    
    func fetchMoreComments(topicHandle: String) {
        if cursor == "" || cursor == nil || isLoading == true {
            return
        }
        
        isLoading = true
        commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, resultHandler: { (result) in
            guard result.error == nil else {
                return
            }
            
            if self.cursor == nil {
                return
            }
            
            self.isLoading = false
            self.cursor = result.cursor
            self.output.didFetchMore(comments: result.comments)
        })
    }
    
    func postComment(photo: Photo?, topicHandle: String, comment: String) {
        let request = PostCommentRequest()
        request.text = comment
        
        commentsService?.postComment(topicHandle: topicHandle, request: request, photo: photo, resultHandler: { (response) in
            self.commentsService?.comment(commentHandle: response.commentHandle!, success: { (comment) in
                self.output.commentDidPosted(comment: comment)
            }, failure: { (errpr) in
                print("error fetching single comment")
            })
        }, failure: { (error) in
            print("error posting comment")
        })
        
    }
    
    func likeComment(comment: Comment) {
        likeService?.likeComment(commentHandle: comment.commentHandle!, completion: { (commentHandle, error) in
            if error != nil {
                return
            }
            
            comment.liked = true
            comment.totalLikes += 1
            self.output.commentLiked(comment: comment)
        })
    }
    
    func unlikeComment(comment: Comment) {
        likeService?.unlikeComment(commentHandle: comment.commentHandle!, completion: { (response, error) in
            if error != nil {
                return
            }
            
            comment.liked = false
            comment.totalLikes -= 1
            self.output.commentUnliked(comment: comment)
        })
    }
}
