//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CrossModuleCoordinator {
    weak var menuModule: SideMenuModuleInput!
    
    private(set) var navigationStack: NavigationStack!
    
    private var isUserLoggedIn = false
    
    func setup(launchArguments args: LaunchArguments, loginHandler: LoginModuleOutput) {
        let sideMenuVC = StoryboardScene.MenuStack.instantiateSideMenuViewController()
        
        navigationStack = NavigationStack(window: args.window, menuViewController: sideMenuVC)
        
        let socialItemsProvider = SocialMenuItemsProvider(coordinator: self,
                                                          loginHandler: loginHandler,
                                                          isUserLoggedIn: isUserLoggedIn)

        menuModule = SideMenuModuleConfigurator.configure(viewController: sideMenuVC,
                                                          configuration: args.menuConfiguration,
                                                          socialMenuItemsProvider: socialItemsProvider,
                                                          clientMenuItemsProvider: args.menuHandler,
                                                          output: navigationStack.container)
    }
    
    func onSessionCreated(user: User, sessionToken: String) {
        isUserLoggedIn = true
        
        menuModule.showUser(user: user)
        
        let nextVC = UIViewController()
        nextVC.view.backgroundColor = .green
        menuModule.open(viewController: nextVC)
    }
}
