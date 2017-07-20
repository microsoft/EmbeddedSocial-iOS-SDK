//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

struct LaunchArguments {
    let app: UIApplication
    let window: UIWindow
    let launchOptions: [AnyHashable: Any]
}

public final class SocialPlus {
    private var launchArguments: LaunchArguments!
    private var root: RootConfigurator!
    private let urlSchemeService = URLSchemeService()
    
    var modelStack: ModelStack!
    
    var coordinator = CrossModuleCoordinator()
    
    public static let shared = SocialPlus()
    
    private init() { }
    
    public func start(with application: UIApplication,
                      window: UIWindow,
                      launchOptions: [AnyHashable: Any],
                      menuHandler: SideMenuItemsProvider?,
                      menuConfiguration: SideMenuType) {
        
        let menuViewController = StoryboardScene.MenuStack.instantiateSideMenuViewController()
        
        navigationStack = NavigationStack(window: window, menuViewController: menuViewController)
        
        coordinator.socialPlus = self
        coordinator.menuModule = buildMenuModule(view: menuViewController,
                                                     configuration: menuConfiguration,
                                                     itemsProvider: menuHandler,
                                                     output: navigationStack.container)
        
        launchArguments = LaunchArguments(app: application, window: window, launchOptions: launchOptions)
        
        ThirdPartyConfigurator.setup(application: launchArguments.app, launchOptions: launchArguments.launchOptions)
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return urlSchemeService.application(app, open: url, options: options)
    }
    
    // MARK: menu
    
    private var navigationStack: NavigationStack!
    
    func buildMenuModule(view: UIViewController,
                         configuration: SideMenuType,
                         itemsProvider: SideMenuItemsProvider?,
                         output: SideMenuModuleOutput!) -> SideMenuModuleInput {
        
        guard let view = view as? SideMenuViewController else {
            fatalError("Wrong input")
        }
    
        let socialItemsProvider = SocialMenuItemsProvider(coordinator: coordinator)
        let moduleInput = SideMenuModuleConfigurator.configure(viewController: view,
                                                               configuration: configuration,
                                                               socialMenuItemsProvider: socialItemsProvider,
                                                               clientMenuItemsProvider: itemsProvider,
                                                               output: output)
        
        return moduleInput
        
    }
}
