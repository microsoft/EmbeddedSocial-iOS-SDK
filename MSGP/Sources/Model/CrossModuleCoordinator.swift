//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

class CrossModuleCoordinator: LoginModuleOutput {
    weak var menuModule: SideMenuModuleInput!
    
    weak var loginHandler: LoginModuleOutput!
    
    private(set) var navigationStack: NavigationStack!
    
    private(set) var isUserLoggedIn = false
    
    func setup(launchArguments args: LaunchArguments, loginHandler: LoginModuleOutput) {
        self.loginHandler = loginHandler
        
        let sideMenuVC = StoryboardScene.MenuStack.instantiateSideMenuViewController()
        
        navigationStack = NavigationStack(window: args.window, menuViewController: sideMenuVC)
        
        let socialItemsProvider = SocialMenuItemsProvider(delegate: self)

        menuModule = SideMenuModuleConfigurator.configure(viewController: sideMenuVC,
                                                          coordinator: self,
                                                          configuration: args.menuConfiguration,
                                                          socialMenuItemsProvider: socialItemsProvider,
                                                          clientMenuItemsProvider: args.menuHandler,
                                                          output: navigationStack.container)
    }
    
    func onSessionCreated(user: User, sessionToken: String) {
        isUserLoggedIn = true
        
        menuModule.user = user
        
        let nextVC = UIViewController()
        nextVC.view.backgroundColor = .green
        menuModule.open(viewController: nextVC)
    }
    
    func openLoginScreen() {
        let configurator = LoginConfigurator()
        configurator.configure(moduleOutput: loginHandler)
        
        menuModule.open(viewController: configurator.viewController)
    }

}
