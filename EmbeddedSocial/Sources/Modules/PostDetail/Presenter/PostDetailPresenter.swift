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
    
    func didFetch(comments: [Comment]) {
        self.comments = comments
        view.reload()
    }
    
    func didFetchMore(comments: [Comment]) {
        
    }
    
    func didFail(error: CommentsServiceError) {
        
    }
    
    // MAKR: PostDetailViewOutput
    func numberOfItems() -> Int {
        return comments.count
    }
    
    func commentForPath(path: IndexPath) -> Comment {
        return comments[path.row]
    }
}
