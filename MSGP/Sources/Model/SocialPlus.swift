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
    public static let shared = SocialPlus()

    fileprivate(set) var modelStack: ModelStack!

    private var launchArguments: LaunchArguments!
    private var root: RootConfigurator!
    
    fileprivate var urlSchemeService: URLSchemeServiceType
    fileprivate var services: SocialPlusServicesType = SocialPlusServices()
    
    private init() {
        urlSchemeService = services.getURLSchemeService()
        let dbFacade = DatabaseFacade(services: services.getDatabaseFacadeServicesProvider())
        modelStack = ModelStack(databaseFacade: dbFacade)
    }
    
    public func start(with application: UIApplication, window: UIWindow, launchOptions: [AnyHashable: Any]) {
        root = RootConfigurator(window: window)
        launchArguments = LaunchArguments(app: application, window: window, launchOptions: launchOptions)
        
        ThirdPartyConfigurator.setup(application: launchArguments.app, launchOptions: launchArguments.launchOptions)
        root.router.openLoginScreen()
        
        root.router.onSessionCreated = { [unowned self] user, sessionToken in
            self.modelStack.createSession(withUser: user, sessionToken: sessionToken)
            self.root.router.openHomeScreen(user: user)
        }
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return urlSchemeService.application(app, open: url, options: options)
    }
}

extension SocialPlus {
    func setServiceProviderForTesting(_ services: SocialPlusServicesType) {
        self.services = services
        urlSchemeService = services.getURLSchemeService()
        let dbFacade = DatabaseFacade(services: services.getDatabaseFacadeServicesProvider())
        modelStack = ModelStack(databaseFacade: dbFacade)
    }
}
