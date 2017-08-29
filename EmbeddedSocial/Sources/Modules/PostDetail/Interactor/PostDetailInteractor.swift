//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

enum CommentSocialAction: Int {
    case like, unlike
}

class PostDetailInteractor: PostDetailInteractorInput {

    weak var output: PostDetailInteractorOutput?
    
    var commentsService: CommentServiceProtocol?
    var topicService: PostServiceProtocol?
    var likeService: LikesServiceProtocol?
    var isLoading = false
    
    // MARK: Social Actions
    
    func commentAction(commentHandle: String, action: CommentSocialAction) {
        
        let completion: LikesServiceProtocol.CommentCompletionHandler = { [weak self] (handle, error) in
                self?.output?.didPostAction(commentHandle: commentHandle, action: action, error: error)
        }
        
        switch action {
        case .like:
            likeService?.likeComment(commentHandle: commentHandle, completion: completion)
        case .unlike:
            likeService?.unlikeComment(commentHandle: commentHandle, completion: completion)
        }
        
    }
    
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32) {
        isLoading = true
        commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
            self.fetchedItems(result: cachedResult)
        }, resultHandler: { (webResult) in
            self.fetchedItems(result: webResult)
        })
    }
    
    private func fetchedItems(result: CommentFetchResult) {
        guard result.error == nil else {
            return
        }
        
        self.isLoading = false
        self.output?.didFetch(comments: result.comments, cursor: result.cursor)
    }
    
    func fetchMoreComments(topicHandle: String, cursor: String?, limit: Int32) {
        if cursor == "" || cursor == nil || isLoading == true {
            return
        }
        
        isLoading = true
        commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
            self.fetchedMoreItems(result: cachedResult)
        }, resultHandler: { (webResult) in
            self.fetchedMoreItems(result: webResult)
        })
    }
    
    private func fetchedMoreItems(result: CommentFetchResult) {
        guard result.error == nil else {
            return
        }
        
        self.isLoading = false
        self.output?.didFetchMore(comments: result.comments, cursor: result.cursor)
    }
    
    func postComment(photo: Photo?, topicHandle: String, comment: String) {
        let request = PostCommentRequest()
        request.text = comment
        
        commentsService?.postComment(topicHandle: topicHandle, request: request, photo: photo, resultHandler: { (response) in
            self.commentsService?.comment(commentHandle: response.commentHandle!, success: { (comment) in
                self.output?.commentDidPosted(comment: comment)
            }, failure: { (errpr) in
                print("error fetching single comment")
            })
        }, failure: { (error) in
            print("error posting comment")
        })
        
    }
    
    func loadPost(topicHandle: String) {
        topicService?.fetchPost(post: topicHandle, completion: { (result) in
            guard let post = result.posts.first else {
                return
            }
            
            self.output?.postFetched(post: post)
        })
    }
}
