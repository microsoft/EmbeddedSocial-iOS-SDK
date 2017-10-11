//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct UserListConfigurator {
    
    func configure(with settings: Settings) -> UserListModuleInput {
        
        let router = UserListRouter()
        router.navController = settings.navigationController
        router.myProfileOpener = settings.myProfileOpener
        router.loginOpener = settings.loginOpener
        
        let view = UserListView()
        
        let listProcessor = PaginatedListProcessor<User>(api: settings.api, pageSize: Constants.UserList.pageSize)
        let interactor = UserListInteractor(listProcessor: listProcessor, socialService: SocialService())
        
        let presenter = UserListPresenter(myProfileHolder: settings.myProfileHolder)
        presenter.view = view
        presenter.moduleOutput = settings.output
        presenter.interactor = interactor
        presenter.router = router
        presenter.noDataText = settings.noDataText
        presenter.noDataView = settings.noDataView
        
        interactor.output = presenter
        
        router.userProfileModuleOutput = presenter

        view.output = presenter
        view.dataManager = UserListDataDisplayManager(myProfileHolder: settings.myProfileHolder,
                                                      builder: settings.listItemsBuilder)
        view.theme = AppConfiguration.shared.theme
        view.dataManager.theme = AppConfiguration.shared.theme
        
        return presenter
    }
}

extension UserListConfigurator {
    
    struct Settings {
        var api: UsersListAPI
        var myProfileHolder: UserHolder
        var myProfileOpener: MyProfileOpener?
        var loginOpener: LoginModalOpener?
        var navigationController: UINavigationController?
        var output: UserListModuleOutput?
        var listItemsBuilder: UserListItemsBuilder
        var noDataText: NSAttributedString?
        var noDataView: UIView?
        
        init(api: UsersListAPI,
             myProfileHolder: UserHolder = SocialPlus.shared,
             myProfileOpener: MyProfileOpener? = SocialPlus.shared.coordinator,
             loginOpener: LoginModalOpener? = SocialPlus.shared.coordinator,
             navigationController: UINavigationController?,
             output: UserListModuleOutput?,
             listItemsBuilder: UserListItemsBuilder = UserListItemsBuilder(),
             noDataText: NSAttributedString? = nil,
             noDataView: UIView? = nil) {
            
            self.api = api
            self.myProfileHolder = myProfileHolder
            self.myProfileOpener = myProfileOpener
            self.loginOpener = loginOpener
            self.navigationController = navigationController
            self.output = output
            self.listItemsBuilder = listItemsBuilder
            self.noDataText = noDataText
            self.noDataView = noDataView
        }
    }
}
