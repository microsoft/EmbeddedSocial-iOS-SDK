//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct BlockedUsersConfigurator {
    
    let viewController: BlockedUsersViewController
    
    init() {
        viewController = StoryboardScene.BlockedUsers.blockedUsersViewController.instantiate()
        viewController.title = L10n.BlockedUsers.screenTitle
    }
    
    func configure(navigationController: UINavigationController?) {
        let presenter = BlockedUsersPresenter()
        presenter.view = viewController
        presenter.usersListModule = makeUserListModule(navigationController: navigationController, output: presenter)
        
        viewController.output = presenter
    }
    
    private func makeUserListModule(navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let api = BlockedUsersAPI(socialService: SocialService())
        
        let noDataText = NSAttributedString(string: L10n.BlockedUsers.noDataText,
                                            attributes: [NSFontAttributeName: AppFonts.medium,
                                                         NSForegroundColorAttributeName: AppConfiguration.shared.theme.palette.textPrimary])
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output,
                                                     listItemsBuilder: BlockedUsersListItemsBuilder(),
                                                     noDataText: noDataText)
        
        return UserListConfigurator().configure(with: settings)
    }
}
