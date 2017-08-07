//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostDetailPresenter: PostDetailModuleInput, PostDetailViewOutput, PostDetailInteractorOutput {

    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    
    var post: Post?
//    var postHandle: String?
    var comments = [Comment]()
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.fetchComments(topicHandle: (post?.topicHandle)!)
    }
    
    
    func likeComment(comment: Comment) {
        
    }
    
    func unlikeComment(comment: Comment) {
        
    }
    
    // MARK: PostDetailInteractorOutput
    func didFetch(comments: [Comment]) {
        self.comments = comments
        view.reload()
    }
    
    func didFetchMore(comments: [Comment]) {
        
    }
    
    func didFail(error: CommentsServiceError) {
        
    }
    
    
    func commentDidPosted(comment: Comment) {
        comments.append(comment)
        view.reload()
    }
    
    func commentPostFailed(error: Error) {
        
    }
    
    // MAKR: PostDetailViewOutput
    func numberOfItems() -> Int {
        return comments.count
    }
    
    func commentForPath(path: IndexPath) -> Comment {
        return comments[path.row]
    }
    
    func postComment(image: UIImage?, comment: String) {
        interactor.postComment(image: image, topicHandle: (post?.topicHandle)!, comment: comment)
    }
}
