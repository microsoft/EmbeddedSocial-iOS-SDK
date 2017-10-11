//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

final class SuggestedUsersConfigurator {
    let viewController: SuggestedUsersViewController
    
    init() {
        viewController = StoryboardScene.SuggestedUsers.suggestedUsersViewController.instantiate()
        viewController.title = L10n.SuggestedUsers.screenTitle
    }
    
    func configure(authorization: Authorization, navigationController: UINavigationController?) {
        let presenter = SuggestedUsersPresenter()
        presenter.view = viewController
        presenter.usersList = makeUserListModule(authorization: authorization,
                                                 navigationController: navigationController,
                                                 output: presenter)
        
        viewController.output = presenter
    }
    
    private func makeUserListModule(authorization: Authorization,
                                    navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let noDataText = NSAttributedString(string: L10n.SuggestedUsers.noDataText,
                                            attributes: [NSFontAttributeName: AppFonts.medium,
                                                         NSForegroundColorAttributeName: AppConfiguration.shared.theme.palette.textPrimary])
        
        let api = SuggestedUsersAPI(socialService: SocialService(), authorization: authorization)
        
        let settings = UserListConfigurator.Settings(api: api,
                                                     navigationController: navigationController,
                                                     output: output,
                                                     noDataText: noDataText)
        
        return UserListConfigurator().configure(with: settings)
    }
}
