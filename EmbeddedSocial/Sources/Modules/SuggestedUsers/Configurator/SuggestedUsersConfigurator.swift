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
    
    func configure(navigationController: UINavigationController?) {
        let presenter = SuggestedUsersPresenter()
        presenter.view = viewController
        presenter.usersList = makeUserListModule(navigationController: navigationController, output: presenter)
        
        viewController.output = presenter
    }
    
    private func makeUserListModule(navigationController: UINavigationController?,
                                    output: UserListModuleOutput?) -> UserListModuleInput {
        
        let noDataText = NSAttributedString(string: L10n.SuggestedUsers.noDataText,
                                            attributes: [NSFontAttributeName: Fonts.medium,
                                                         NSForegroundColorAttributeName: Palette.darkGrey])
        
        let settings = UserListConfigurator.Settings(api: SuggestedUsersAPI(socialService: SocialService()),
                                                     navigationController: navigationController,
                                                     output: output,
                                                     noDataText: noDataText)
        
        return UserListConfigurator().configure(with: settings)
    }
}
