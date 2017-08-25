//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct LikesListConfigurator {
    
    let viewController: LikesListViewController
    
    init() {
        viewController = StoryboardScene.LikesList.instantiateLikesListViewController()
        viewController.title = L10n.LikesList.screenTitle
    }
    
    func configure(postHandle: String) {
        let presenter = LikesListPresenter()
        presenter.view = viewController
        presenter.interactor = LikesListInteractor()
        
        let api = LikesListAPI(postHandle: postHandle, likesService: LikesService())
        presenter.usersListModule = UserListConfigurator().configure(api: api, output: presenter)
        
        viewController.output = presenter
    }
}
