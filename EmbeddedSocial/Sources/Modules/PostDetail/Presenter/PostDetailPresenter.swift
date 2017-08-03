//
//  PostDetailPostDetailPresenter.swift
//  EmbeddedSocial-Framework
//
//  Created by generamba setup on 31/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class PostDetailPresenter: PostDetailModuleInput, PostDetailViewOutput, PostDetailInteractorOutput {
    var postHandle: String = ""


    weak var view: PostDetailViewInput!
    var interactor: PostDetailInteractorInput!
    var router: PostDetailRouterInput!
    
    var post: Post?
//    var postHandle: String?
    var comments = [Comment]()
    
    func viewIsReady() {
        view.setupInitialState()
        interactor.fetchComments(topicHandle: postHandle)
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
