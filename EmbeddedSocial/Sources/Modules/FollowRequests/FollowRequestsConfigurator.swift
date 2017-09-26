//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct FollowRequestsConfigurator {
    
    let viewController: FollowRequestsViewController
    
    init() {
        viewController = StoryboardScene.FollowRequests.instantiateFollowRequestsViewController()
        viewController.title = L10n.FollowRequests.screenTitle.uppercased()
    }
    
    func configure(navigationController: UINavigationController?) {
        let listProcessor = UsersListProcessor(api: FollowRequestsAPI(activityService: SocialService()))
        let interactor = FollowRequestsInteractor(listProcessor: listProcessor, activityService: SocialService())
        
        let noDataText = NSAttributedString(string: L10n.FollowRequests.noDataText,
                                            attributes: [NSFontAttributeName: Fonts.medium,
                                                         NSForegroundColorAttributeName: Palette.darkGrey])
        
        let presenter = FollowRequestsPresenter(noDataText: noDataText)
        presenter.router = FollowRequestsRouter(navigationController: navigationController)
        presenter.interactor = interactor
        presenter.view = viewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        viewController.dataManager = FollowRequestsDataDisplayManager()
    }
}
