//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CreatePostPresenter: CreatePostModuleInput, CreatePostViewOutput, CreatePostInteractorOutput {
    
    weak var view: CreatePostViewInput!
    var interactor: CreatePostInteractorInput!
    var router: CreatePostRouterInput!

    // MARK: CreatePostViewOutput
    func viewIsReady() {
        view.setupInitialState()
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
        view.showError(error: error)
    }
}
