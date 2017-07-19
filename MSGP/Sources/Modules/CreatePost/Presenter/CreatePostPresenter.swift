//
//  CreatePostCreatePostPresenter.swift
//  MSGP-Framework
//
//  Created by generamba setup on 12/07/2017.
//  Copyright © 2017 akvelon. All rights reserved.
//

class CreatePostPresenter: CreatePostModuleInput, CreatePostViewOutput, CreatePostInteractorOutput {
    
    weak var view: CreatePostViewInput!
    var interactor: CreatePostInteractorInput!
    var router: CreatePostRouterInput!
    
    var user: User?

    // MARK: CreatePostViewOutput
    func viewIsReady() {
        view.setupInitialState()
        view.show(user: user!)
    }
    
    func post(image: UIImage?, title: String?, body: String!) {
        interactor.postTopic(image: image, title: title, body: body)
    }
    
    func back() {
        guard let vc = view as? UIViewController else {
            return
        }
        
        router.back(from: vc)
    }
    
    // MARK: CreatePostInteractorOutput
    func created(post: PostTopicResponse) {
        // TODO: handle
    }
    
    func postCreationFailed(error: Error) {
        view.show(error: error)
    }
}
