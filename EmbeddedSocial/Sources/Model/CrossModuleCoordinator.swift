//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CrossModuleCoordinatorConfigurator {
    
    func configureHome() -> UIViewController
    
}

protocol CrossModuleCoordinatorProtocol: class {
    
    func closeMenu()
    
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
    fileprivate var cache: Cache
    
    required init(cache: Cache) {
        self.cache = cache
    }
    
    func setup(launchArguments args: LaunchArguments, loginHandler: LoginModuleOutput) {
        self.loginHandler = loginHandler
    
        let socialMenuHandler = SocialMenuItemsProvider(coordinator: self)
        
        let configurator = SideMenuModuleConfigurator()
        
        configurator.configure(coordinator: self,
                               configuration: args.menuConfiguration,
                               socialMenuItemsProvider: socialMenuHandler,
                               clientMenuItemsProvider: args.menuHandler)
        
        menuModule = configurator.moduleInput
        navigationStack = NavigationStack(window: args.window, menuViewController: configurator.viewController)
        
        configurator.router.output = navigationStack
    }

    // MARK: Login Delegate
    func onSessionCreated(user: User, sessionToken: String) {
        
        self.user = user
        menuModule.user = user
        
        openHomeScreen()
        closeMenu()
    }
    
    // MARK: Protocol
    
    func closeMenu() {
        menuModule.close()
    }
    
    func isUserAuthenticated() -> Bool {
        return (user != nil)
    }
    
    func openLoginScreen() {
        let configurator = LoginConfigurator()
        configurator.configure(moduleOutput: loginHandler)
        navigationStack.show(configurator.viewController)
    }
    
    func openMyProfile() {
        let configurator = UserProfileConfigurator()
        configurator.configure()
        navigationStack.show(configurator.viewController)
    }
    
    func openHomeScreen() {
        let vc = configureHome()
        navigationStack.show(vc)
    }
}

extension CrossModuleCoordinator: CrossModuleCoordinatorConfigurator {
    
    func configureHome() -> UIViewController {
        let configurator = FeedModuleConfigurator(cache: self.cache)
        configurator.configure(navigationController: navigationStack.navigationController)
        configurator.moduleInput.setFeed(.home)
        configurator.viewController.title = "Home"
        let vc = configurator.viewController!
        return vc
    }
    
    func configurePopular() -> UIViewController {
        let configurator = FeedModuleConfigurator(cache: self.cache)
        configurator.configure(navigationController: navigationStack.navigationController)
        configurator.moduleInput.setFeed(.popular(type: .alltime))
        configurator.viewController.title = "Popular"
        let vc = configurator.viewController!
        return vc
    }
    
    func configurePostMenu() -> UIViewController {
        let configurator = PostMenuModuleConfigurator()
        configurator.configure(post: "3uRFIMWAT3P")
        configurator.viewController.title = "Debug"
        let vc = configurator.viewController!
        return vc
    }
    
}
