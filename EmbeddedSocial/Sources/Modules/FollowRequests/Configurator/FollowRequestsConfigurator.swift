//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct FollowRequestsConfigurator {
    
    let viewController: FollowRequestsViewController
    
    init() {
        viewController = StoryboardScene.FollowRequests.followRequestsViewController.instantiate()
        viewController.title = L10n.FollowRequests.screenTitle.uppercased()
    }
    
    func configure(output: FollowRequestsModuleOutput?, navigationController: UINavigationController?) {
        let listProcessor = PaginatedListProcessor<User>(api: FollowRequestsAPI(activityService: SocialService()),
                                                         pageSize: Constants.UserList.pageSize)
        let interactor = FollowRequestsInteractor(listProcessor: listProcessor, socialService: SocialService())
        
        let noDataText = NSAttributedString(string: L10n.FollowRequests.noDataText,
                                            attributes: [.font: AppFonts.medium,
                                                         .foregroundColor: Palette.darkGrey])
        
        let presenter = FollowRequestsPresenter(noDataText: noDataText)
        presenter.router = FollowRequestsRouter(navigationController: navigationController)
        presenter.interactor = interactor
        presenter.view = viewController
        presenter.output = output
        
        interactor.output = presenter
        
        viewController.output = presenter
        viewController.dataManager = FollowRequestsDataDisplayManager()
        viewController.theme = AppConfiguration.shared.theme
    }
}
