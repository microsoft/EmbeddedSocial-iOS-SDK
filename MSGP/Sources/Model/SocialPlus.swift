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
    
    private(set) var sessionStore: SessionStore!

    private var launchArguments: LaunchArguments!
    private var root: RootConfigurator!
    
    fileprivate var urlSchemeService: URLSchemeServiceType!
    fileprivate var services: SocialPlusServicesType!
    
    private init() {
        setupServices(with: SocialPlusServices())
        try? sessionStore.loadLastSession()
    }
    
    func setupServices(with serviceProvider: SocialPlusServicesType) {
        services = serviceProvider
        urlSchemeService = services.getURLSchemeService()
        let database = SessionStoreDatabaseFacade(services: services.getSessionStoreRepositoriesProvider())
        sessionStore = SessionStore(database: database)
    }
    
    public func start(with application: UIApplication, window: UIWindow, launchOptions: [AnyHashable: Any]) {
        root = RootConfigurator(window: window)
        root.router.onSessionCreated = { [unowned self] user, sessionToken in
            self.sessionStore.createSession(withUser: user, sessionToken: sessionToken)
            try? self.sessionStore.saveCurrentSession()
            self.root.router.openHomeScreen(user: user)
        }
        
        launchArguments = LaunchArguments(app: application, window: window, launchOptions: launchOptions)
        
        ThirdPartyConfigurator.setup(application: launchArguments.app, launchOptions: launchArguments.launchOptions)
        
        if sessionStore.isLoggedIn {
            root.router.openHomeScreen(user: sessionStore.user)
        } else {
            root.router.openLoginScreen()
        }
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return urlSchemeService.application(app, open: url, options: options)
    }
}
