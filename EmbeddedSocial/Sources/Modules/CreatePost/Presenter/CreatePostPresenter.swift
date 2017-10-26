//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreatePostPresenter: CreatePostModuleInput, CreatePostViewOutput, CreatePostInteractorOutput {
    
    weak var view: CreatePostViewInput!
    var interactor: CreatePostInteractorInput!
    var router: CreatePostRouterInput!
    weak var moduleOutput: CreatePostModuleOutput?
    
    var user: User?
    var post: Post?

    // MARK: CreatePostViewOutput
    func viewIsReady() {
        view.setupInitialState()
        view.show(user: user!)
        
        guard let post = post else {
            view.configTitlesWithoutPost()
            return
        }
        
        view.configTitlesForExistingPost()
        view.show(post: post)
    }
    
    func post(photo: Photo?, title: String?, body: String!) {
        guard let post = post else {
            interactor.postTopic(photo: photo, title: title, body: body)
            return
        }
        
        interactor.update(topic: post, title: title, body: body)
    }
    
    func back() {
        guard let vc = view as? UIViewController else {
            return
        }
        
        router.back(from: vc)
    }
    
    // MARK: CreatePostInteractorOutput
    
    func postUpdateFailed(error: Error) {
        view.show(error: error)
    }
    
    func postUpdated() {
        view.topicUpdated()
        moduleOutput?.didUpdatePost()
        back()
    }
    
    func created() {
        // TODO: handle
        view.topicCreated()
        moduleOutput?.didCreatePost()
        back()
    }
    
    func postCreationFailed(error: Error) {
        view.show(error: error)
    }
}
