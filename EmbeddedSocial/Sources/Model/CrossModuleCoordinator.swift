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
    var configuredSettings: UIViewController { get }
    var configuredMyPins: UIViewController { get }
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

    func onSessionCreated(with info: SessionInfo) {
        
        Logger.log(info.user.credentials?.authorization, event: .important)
        
        self.user = info.user
        menuModule.user = info.user
        
        if info.source == .menu {
            navigationStack.cleanStack()
            openHomeScreen()
            closeMenu()
        } else if info.source == .modal {
            navigationStack.dismissModal()
        }
    }
    
    func onSessionCreated(user: User, sessionToken: String) {
        let info = SessionInfo(user: user, token: sessionToken, source: .menu)
        onSessionCreated(with: info)
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
        navigationStack.cleanStack()
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
    
    lazy var configuredMyPins: UIViewController = {
        let configurator = FeedModuleConfigurator(cache: self.cache)
        configurator.configure(navigationController: self.navigationStack.navigationController)
        configurator.moduleInput.feedType = (.myPins)
        configurator.viewController.title = L10n.MyPins.screenTitle
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
    
    lazy var configuredSettings: UIViewController = {
        let configurator = SettingsConfigurator()
        configurator.configure(navigationController: self.navigationStack.navigationController)
        return configurator.viewController
    }()
}

extension CrossModuleCoordinator: MyProfileOpener { }

extension CrossModuleCoordinator: LoginModalOpener {
    
    func openLogin(parentViewController: UIViewController?) {
        let configurator = LoginConfigurator()
        configurator.configure(moduleOutput: loginHandler, source: .modal)
        let navController = UINavigationController(rootViewController: configurator.viewController)
        navigationStack.presentModal(navController, parentViewController: parentViewController)
    }
}
