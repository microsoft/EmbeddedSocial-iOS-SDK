//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct LikesListConfigurator {
    
    let viewController: LikesListViewController
    
    init() {
        viewController = StoryboardScene.LikesList.likesListViewController.instantiate()
        viewController.title = L10n.LikesList.screenTitle
    }
    
    func configure(handle: String, type: LikedObject, navigationController: UINavigationController?) {
        let presenter = LikesListPresenter()
        presenter.view = viewController
        presenter.interactor = LikesListInteractor()
        
        let api = LikesListAPI(handle: handle, type: type, likesService: LikesService())

        presenter.usersListModule = makeUserListModule(api: api,
                                                       noDataText: type.noDataText,
                                                       navigationController: navigationController,
                                                       output: presenter)
        
        viewController.output = presenter
    }
    
    private func makeUserListModule(api: UsersListAPI,
                                    noDataText: String,
                                    navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {

        let noDataText = NSAttributedString(string: noDataText,
                                            attributes: [NSFontAttributeName: AppFonts.medium,
                                                         NSForegroundColorAttributeName: AppConfiguration.shared.theme.palette.textPrimary])
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output,
                                                     noDataText: noDataText)
        
        return UserListConfigurator().configure(with: settings)
    }
}
