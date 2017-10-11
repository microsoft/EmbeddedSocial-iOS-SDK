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
    func openSearchPeople()

    func logOut()
    func showError(_ error: Error)

    func isUserAuthenticated() -> Bool
    
    var configuredHome: UIViewController { get }
    var configuredPopular: UIViewController { get }
    var configuredUserProfile: UIViewController { get }
    var configuredLogin: UIViewController { get }
    var configuredSearch: UIViewController { get }
    var configuredSettings: UIViewController { get }
    var configuredMyPins: UIViewController { get }
    var configuredActivity: UIViewController { get }
}

class CrossModuleCoordinator: CrossModuleCoordinatorProtocol, LoginModuleOutput {
    
    private(set) weak var menuModule: SideMenuModuleInput!
    private(set) weak var loginHandler: LoginModuleOutput!
    private(set) var menuItemsProvider: SocialMenuItemsProvider!
    private(set) var navigationStack: NavigationStack!
    private(set) var user: User?
    fileprivate var cache: CacheType
    
    fileprivate var screens: [SocialItem: UIViewController] = [:]
    fileprivate var searchConfigurator: SearchConfigurator?
    
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
    
    func openActivityScreen() {
        let index = menuItemsProvider.getMenuItemIndex(for: .activity)!
        menuModule.openSocialItem(index: index)
    }
    
    func openSearchPeople() {
        let index = menuItemsProvider.getMenuItemIndex(for: .search)!
        menuModule.openSocialItem(index: index)
        searchModule.selectPeopleTab()
    }
    
    func logOut() {
        user = nil
        menuModule.user = nil
        searchConfigurator = nil
        screens = [:]
        navigationStack.cleanStack()
        openLoginScreen()
    }
    
    func showError(_ error: Error) {
        navigationStack.showError(error)
    }
    
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
    
    var configuredHome: UIViewController {
        return screen(for: .home, maker: makeHome)
    }
    
    var configuredPopular: UIViewController {
        return screen(for: .popular, maker: makePopular)
    }
    
    var configuredMyPins: UIViewController {
        return screen(for: .myPins, maker: makeMyPins)
    }
    
    var configuredSettings: UIViewController {
        return screen(for: .settings, maker: makeSettings)
    }
    
    var configuredSearchModule: SearchConfigurator {
        if searchConfigurator == nil {
            searchConfigurator = SearchConfigurator()
            searchConfigurator!.configure(isLoggedInUser: isUserAuthenticated(),
                                          navigationController: navigationStack.navigationController)
        }
        return searchConfigurator!
    }
    
    var configuredSearch: UIViewController {
        return configuredSearchModule.viewController
    }
    
    var searchModule: SearchModuleInput {
        return configuredSearchModule.moduleInput
    }
    
    var configuredActivity: UIViewController {
        return screen(for: .activity, maker: makeActivity)
    }
    
    private func screen(for item: SocialItem, maker: () -> UIViewController) -> UIViewController {
        if screens[item] == nil {
            screens[item] = maker()
        }
        return screens[item]!
    }
    
    private func makeHome() -> UIViewController {
        let configurator = FeedModuleConfigurator(cache: cache)
        configurator.configure(navigationController: navigationStack.navigationController)
        configurator.moduleInput.feedType = .home
        configurator.viewController.title = L10n.Home.screenTitle
        return configurator.viewController
    }
    
    private func makePopular() -> UIViewController {
        let configurator = PopularModuleConfigurator()
        configurator.configure(navigationController: navigationStack.navigationController)
        configurator.viewController.title = L10n.Popular.screenTitle
        return configurator.viewController
    }
    
    private func makeMyPins() -> UIViewController {
        let configurator = FeedModuleConfigurator(cache: cache)
        configurator.configure(navigationController: navigationStack.navigationController)
        configurator.moduleInput.feedType = (.myPins)
        configurator.viewController.title = L10n.MyPins.screenTitle
        return configurator.viewController
    }
    
    private func makeConfiguredSearch() -> SearchConfigurator {
        let configurator = SearchConfigurator()
        configurator.configure(isLoggedInUser: isUserAuthenticated(),
                               navigationController: navigationStack.navigationController)
        return configurator
    }
    
    private func makeSettings() -> UIViewController {
        let configurator = SettingsConfigurator()
        configurator.configure(navigationController: navigationStack.navigationController)
        return configurator.viewController
    }
    
    private func makeActivity() -> UIViewController {
        let configurator = ActivityModuleConfigurator()
        configurator.configure(navigationController: navigationStack.navigationController)
        return configurator.viewController
    }
}

extension CrossModuleCoordinator: MyProfileOpener { }

extension CrossModuleCoordinator: SearchPeopleOpener { }

extension CrossModuleCoordinator: LoginModalOpener {
    
    func openLogin(parentViewController: UIViewController?) {
        let configurator = LoginConfigurator()
        configurator.configure(moduleOutput: loginHandler, source: .modal)
        let navController = BaseNavigationController(rootViewController: configurator.viewController)
        navigationStack.presentModal(navController, parentViewController: parentViewController)
    }
}
