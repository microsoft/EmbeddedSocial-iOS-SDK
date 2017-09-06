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
    
    func configure(postHandle: String, navigationController: UINavigationController?) {
        let presenter = LikesListPresenter()
        presenter.view = viewController
        presenter.interactor = LikesListInteractor()
        presenter.usersListModule = makeUserListModule(postHandle: postHandle,
                                                       navigationController: navigationController,
                                                       output: presenter)
        
        viewController.output = presenter
    }
    
    private func makeUserListModule(postHandle: String,
                                    navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let api = LikesListAPI(postHandle: postHandle, likesService: LikesService())
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output)
        
        return UserListConfigurator().configure(with: settings)
    }
}
