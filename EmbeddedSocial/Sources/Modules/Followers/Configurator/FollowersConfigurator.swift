//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class FollowersConfigurator {
    let viewController: FollowersViewController
    
    init() {
        viewController = StoryboardScene.Followers.followersViewController.instantiate()
        viewController.title = L10n.Followers.screenTitle
    }
    
    func configure(api: UsersListAPI,
                   navigationController: UINavigationController?,
                   moduleOutput: FollowersModuleOutput? = nil) {
        
        let presenter = FollowersPresenter()
        presenter.view = viewController
        presenter.usersList = makeUserListModule(api: api, navigationController: navigationController, output: presenter)
        presenter.moduleOutput = moduleOutput
        
        viewController.output = presenter
    }
    
    private func makeUserListModule(api: UsersListAPI,
                                    navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let noDataText = NSAttributedString(string: L10n.Followers.noDataText,
                                            attributes: [.font: AppFonts.medium,
                                                         .foregroundColor: AppConfiguration.shared.theme.palette.textPrimary])
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output,
                                                     noDataText: noDataText)
        
        return UserListConfigurator().configure(with: settings)
    }
}
