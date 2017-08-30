//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol CrossModuleCoordinatorProtocol: class {
    
    func closeMenu()
    
    func openHomeScreen()
    func openPopularScreen()
    func openMyProfile()
    func openLoginScreen()
    
    func logOut()
    func showError(_ error: Error)

    func isUserAuthenticated() -> Bool
    
    var configuredHome: UIViewController! { get }
    var configuredPopular: UIViewController! { get }
    var configuredUserProfile: UIViewController { get }
    var configuredLogin: UIViewController { get }
    var configuredSearch: UIViewController { get }
}

class CrossModuleCoordinator: CrossModuleCoordinatorProtocol, LoginModuleOutput {
    
    private(set) weak var menuModule: SideMenuModuleInput!
    private(set) weak var loginHandler: LoginModuleOutput!
    private(set) var menuItemsProvider: SocialMenuItemsProvider!
    private(set) var navigationStack: NavigationStack!
    private(set) var user: User?
    fileprivate var cache: CacheType
    
    required init(cache: CacheType) {
        self.cache = cache
    }
    
    func setup(launchArguments args: LaunchArguments, loginHandler: LoginModuleOutput) {
        self.loginHandler = loginHandler
    
        menuItemsProvider = SocialMenuItemsProvider(coordinator: self)
    
        
        let configurator = SideMenuModuleConfigurator()
        
        configurator.configure(coordinator: self,
                               configuration: args.menuConfiguration,
                               socialMenuItemsProvider: menuItemsProvider,
                               clientMenuItemsProvider: args.menuHandler)
        
        menuModule = configurator.moduleInput
        navigationStack = NavigationStack(window: args.window, menuViewController: configurator.viewController)
        
        configurator.router.output = navigationStack
    }

    func onSessionCreated(user: User, sessionToken: String) {
        
        Logger.log(user.credentials?.authorization, event: .important)
        
        self.user = user
        menuModule.user = user
        
        openHomeScreen()
        closeMenu()
    }
    
    func updateUser(_ user: User) {
        self.user = user
        menuModule.user = user
    }
    
    // MARK: Protocol
    
    func closeMenu() {
        menuModule.close()
    }
    
    func isUserAuthenticated() -> Bool {
        return (user != nil)
    }
    
    func openLoginScreen() {
        menuModule.openLogin()
    }
    
    func openMyProfile() {
        menuModule.openMyProfile()
    }
    
    func openHomeScreen() {
        let index = menuItemsProvider.getMenuItemIndex(for: .home)!
        menuModule.openSocialItem(index: index)
    }
    
    func openPopularScreen() {
        let index = menuItemsProvider.getMenuItemIndex(for: .popular)!
        menuModule.openSocialItem(index: index)
    }
    
    func logOut() {
        user = nil
        menuModule.user = nil
        configuredHome = nil
        configuredPopular = nil
        openLoginScreen()
    }
    
    func showError(_ error: Error) {
        navigationStack.showError(error)
    }
    
    // MARK: Modules Builder
    var configuredLogin: UIViewController {
        let configurator = LoginConfigurator()
        configurator.configure(moduleOutput: loginHandler)
        return configurator.viewController
    }
    
    var configuredUserProfile: UIViewController {
        let configurator = UserProfileConfigurator()
        configurator.configure(navigationController: navigationStack.navigationController)
        return configurator.viewController
    }
    
    lazy var configuredHome: UIViewController! = {
        let configurator = FeedModuleConfigurator(cache: self.cache)
        configurator.configure(navigationController: self.navigationStack.navigationController)
        configurator.moduleInput.feedType = (.home)
        configurator.viewController.title = L10n.Home.screenTitle
        let vc = configurator.viewController!
        return vc
    }()

    lazy var configuredPopular: UIViewController! = {
        let configurator = PopularModuleConfigurator()
        configurator.configure(navigationController: self.navigationStack.navigationController)
        configurator.viewController.title = L10n.Popular.screenTitle
        let vc = configurator.viewController!
        return vc
    }()

    lazy var configuredDebug: UIViewController = {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.purple
        return vc
    }()
    
    lazy var configuredSearch: UIViewController = {
        let configurator = SearchConfigurator()
        configurator.configure(isLoggedInUser: self.isUserAuthenticated(),
                               navigationController: self.navigationStack.navigationController)
        return configurator.viewController
    }()
    
}

extension CrossModuleCoordinator: MyProfileOpener { }
