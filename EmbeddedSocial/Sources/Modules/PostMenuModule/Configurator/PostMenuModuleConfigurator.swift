//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//


import UIKit

class PostMenuModuleConfigurator {
    
    var viewController: PostMenuModuleViewController!
    var moduleInput: PostMenuModuleModuleInput!

    func configure(post: PostHandle) {
        
        viewController = PostMenuModuleViewController()
        
        let router = PostMenuModuleRouter()

        let presenter = PostMenuModulePresenter()
        presenter.view = viewController
        presenter.router = router
        presenter.postHandle = post

        let interactor = PostMenuModuleInteractor()
        interactor.output = presenter

        
        presenter.interactor = interactor
        
        viewController.output = presenter
        
        viewController.view.backgroundColor = UIColor.clear
    }
}
