//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class PostDetailPresenter: PostDetailModuleInput, PostDetailViewOutput, PostDetailInteractorOutput {

    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    
    var post: Post?

    var comments = [Comment]()
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.fetchComments(topicHandle: (post?.topicHandle)!)
    }
    
    func likeComment(comment: Comment) {
        interactor.likeComment(comment: comment)
    }
    
    func unlikeComment(comment: Comment) {
        interactor.unlikeComment(comment: comment)
    }
    
    // MARK: PostDetailInteractorOutput
    func didFetch(comments: [Comment]) {
        self.comments = comments
        view.reload(animated: true)
    }
    
    func didFetchMore(comments: [Comment]) {
        self.comments.append(contentsOf: comments)
        view.reloadTable()
    }
    
    func didFail(error: CommentsServiceError) {
    }
    
    
    func commentDidPosted(comment: Comment) {
        comments.append(comment)
        view.postCommentSuccess()
    }
    
    func commentPostFailed(error: Error) {
        
    }
    
    // MAKR: PostDetailViewOutput
    func numberOfItems() -> Int {
        return comments.count
    }
    
    func fetchMore() {
        interactor.fetchMoreComments(topicHandle: (post?.topicHandle)!)
    }
    
    func commentForPath(path: IndexPath) -> Comment {
        return comments[path.row]
    }
    
    func postComment(image: UIImage?, comment: String) {
        interactor.postComment(image: image, topicHandle: (post?.topicHandle)!, comment: comment)
    }
}
