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
    var isLoading = false
    
    func fetchComments(topicHandle: String, cursor: String?, limit: Int32) {
        DispatchQueue.global(qos: .background).async {
            self.isLoading = true
            self.commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
                DispatchQueue.main.async {
                    self.fetchedItems(result: cachedResult)
                }
            }, resultHandler: { (webResult) in
                DispatchQueue.main.async {
                    self.fetchedItems(result: webResult)
                }
            })
        }

    }
    
    private func fetchedItems(result: CommentFetchResult) {
        guard result.error == nil else {
            return
        }
        
        self.isLoading = false
        self.output?.didFetch(comments: result.comments, cursor: result.cursor)
    }
    
    func fetchMoreComments(topicHandle: String, cursor: String?, limit: Int32) {
        
        DispatchQueue.global(qos: .background).async {
            
            if cursor == "" || cursor == nil || self.isLoading == true {
                    return
            }
            
            self.isLoading = true
            self.commentsService?.fetchComments(topicHandle: topicHandle, cursor: cursor, limit: limit, cachedResult: { (cachedResult) in
                DispatchQueue.main.async {
                    self.fetchedMoreItems(result: cachedResult)
                }
                
            }, resultHandler: { (webResult) in
                DispatchQueue.main.async {
                    self.fetchedMoreItems(result: webResult)
                }
            })
        }

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
            self.commentsService?.comment(commentHandle: response.commentHandle!, cachedResult: { (cachedComment) in
                self.output?.commentDidPost(comment: cachedComment)
            }, success: { (webComment) in
                self.output?.commentDidPost(comment: webComment)
            }, failure: { (errpr) in
                print("error fetching single comment")
            })

        }, failure: { (error) in
            print("error posting comment")
        })
        
    }
}
