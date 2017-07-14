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
    private let launchArguments: LaunchArguments
    private let root: RootConfigurator
    private let urlSchemeService = URLSchemeService()
    
    public init(application: UIApplication, window: UIWindow, launchOptions: [AnyHashable: Any]) {
        root = RootConfigurator(window: window)
        launchArguments = LaunchArguments(app: application, window: window, launchOptions: launchOptions)
    }
    
    public func start() {
        ThirdPartyConfigurator.setup(application: launchArguments.app, launchOptions: launchArguments.launchOptions)
        root.router.openLoginScreen()
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return urlSchemeService.application(app, open: url, options: options)
    }
}
