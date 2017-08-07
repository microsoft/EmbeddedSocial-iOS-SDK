//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CrossModuleCoordinatorProtocol: class {
    
    func openHomeScreen()
    func openMyProfile()
    func openLoginScreen()

    func isUserAuthenticated() -> Bool
}

class CrossModuleCoordinator: CrossModuleCoordinatorProtocol, LoginModuleOutput {
    
    weak var menuModule: SideMenuModuleInput!
    weak var loginHandler: LoginModuleOutput!
    private(set) var navigationStack: NavigationStack!
    private(set) var user: User?
    private var cache: Cache
    
    required init(cache: Cache) {
        self.cache = cache
    }
    
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

    // MARK: Login Delegate
    func onSessionCreated(user: User, sessionToken: String) {
        
        self.user = user
        menuModule.user = user
        
        openHomeScreen()
    }
    
    // MARK: Protocol
    
    func isUserAuthenticated() -> Bool {
        return (user != nil)
    }
    
    func openLoginScreen() {
        let configurator = LoginConfigurator()
        configurator.configure(moduleOutput: loginHandler)
        
        menuModule.open(viewController: configurator.viewController)
    }
    
    func openMyProfile() {
        let configurator = UserProfileConfigurator()
        configurator.configure()
        menuModule.open(viewController: configurator.viewController)
    }
    
    func openHomeScreen() {
        let configurator = FeedModuleConfigurator(cache: self.cache)
        configurator.configure(feed: FeedType.home, navigationController: navigationStack.navigationController)
        let vc = configurator.viewController!
        navigationStack.navigationController.show(vc, sender: nil)
    }
    
}
