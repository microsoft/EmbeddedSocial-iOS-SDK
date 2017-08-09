//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


protocol PostMenuModuleModuleInput: class {
    
}

class PostMenuModulePresenter: PostMenuModuleModuleInput, PostMenuModuleViewOutput, PostMenuModuleInteractorOutput {

    weak var view: PostMenuModuleViewInput!
    var interactor: PostMenuModuleInteractorInput!
    var router: PostMenuModuleRouterInput!

    func viewIsReady() {

    }
}
