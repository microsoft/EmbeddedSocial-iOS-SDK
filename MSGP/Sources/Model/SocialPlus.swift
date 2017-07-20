//
//  SocialPlus.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Akvelon. All rights reserved.
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
    
    var coordinator: CrossModuleCoordinator!
    
    public static let shared = SocialPlus()
    
    private init() { }
    
    public func start(with application: UIApplication,
                      window: UIWindow,
                      launchOptions: [AnyHashable: Any],
                      menuHandler: SideMenuItemsProvider?,
                      menuConfiguration: SideMenuType) {
        
        let menuViewController = StoryboardScene.MenuStack.instantiateSideMenuViewController()
        
        navigationStack = NavigationStack(window: window, menuViewController: menuViewController)
        
        let menuModule = buildMenuModule(view: menuViewController,
                                         configuration: menuConfiguration,
                                         itemsProvider: menuHandler,
                                         output: navigationStack.container)
        
        coordinator = CrossModuleCoordinator(socialPlus: self, menuModule: menuModule)
        
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
        
        let moduleInput = SideMenuModuleConfigurator.configure(viewController: view,
                                                               configuration: configuration,
                                                               socialMenuItemsProvider: SocialMenuItemsProvider(),
                                                               clientMenuItemsProvider: itemsProvider,
                                                               output: output)
        
        return moduleInput
        
    }
}
