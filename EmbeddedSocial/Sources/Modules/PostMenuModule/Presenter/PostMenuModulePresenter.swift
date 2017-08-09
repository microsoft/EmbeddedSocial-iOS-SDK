//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


protocol PostMenuModuleModuleInput: class {
    
}

class PostMenuModulePresenter: PostMenuModuleViewOutput, PostMenuModuleModuleInput, PostMenuModuleInteractorOutput {

    weak var view: PostMenuModuleViewInput!
    var interactor: PostMenuModuleInteractorInput!
    var router: PostMenuModuleRouterInput!
    
    func viewIsReady() {
        
        view.addAction(title: "test") {
            Logger.log("test 1")
        }
        
        view.addAction(title: "test 2") {
            Logger.log("test 2")
        }
        
    }

}
