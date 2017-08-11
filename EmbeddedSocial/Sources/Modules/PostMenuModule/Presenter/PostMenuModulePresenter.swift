//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol PostMenuModuleModuleOutput: class {
    

}

protocol PostMenuModuleModuleInput: class {

}

enum PostMenuType {
    
    case myPost(post: PostHandle),
    case otherPost(post: PostHandle)
}


class PostMenuModulePresenter: PostMenuModuleViewOutput, PostMenuModuleModuleInput, PostMenuModuleInteractorOutput {

    weak var view: PostMenuModuleViewInput!
    var interactor: PostMenuModuleInteractorInput!
    var router: PostMenuModuleRouterInput!
    var postHandle: PostHandle!
    var menuType: PostMenuType!
    
    
    func viewIsReady() {
        
        view.addAction(title: "") {
            Logger.log("test 1")
        }
        
        view.addAction(title: "test 2") {
            Logger.log("test 2")
        }
    }
    
    // MARK: Interactor Output
    
    func didBlock(user: UserHandle, error: Error?) {
        
    }
    
    func didRepost(user: UserHandle, error: Error?) {
        
    }
    
    func didFollow(user: UserHandle, error: Error?) {
        
    }
    
    func didUnFollow(user: UserHandle, error: Error?) {
        
    }
    
    func didHide(post: PostHandle, error: Error?) {
        
    }
    
    func didEdit(post: PostHandle, error: Error?) {
        
    }
    
    func didRemove(post: PostHandle, error: Error?) {
        
    }
    
    

}
