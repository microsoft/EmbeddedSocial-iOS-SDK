//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UsersWhoLikedPostConfigurator {
    
    let viewController: UsersWhoLikedPostViewController
    
    init() {
        viewController = StoryboardScene.UsersWhoLikedPost.instantiateUsersWhoLikedPostViewController()
        viewController.title = L10n.LikesList.screenTitle
    }
    
    func configure(postHandle: String) {
        let presenter = UsersWhoLikedPostPresenter()
        presenter.view = viewController
        presenter.interactor = UsersWhoLikedPostInteractor()
        
        let api = UsersWhoLikedPostAPI(postHandle: postHandle, likesService: LikesService())
        presenter.usersListModule = UserListConfigurator().configure(api: api, output: presenter)
        
        viewController.output = presenter
    }
}
