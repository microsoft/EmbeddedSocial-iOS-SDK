//
//  MSGP.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

public final class MSGP {
    private let app: UIApplication
    private let window: UIWindow
    private let root: RootConfigurator
    private let thirdPartyConfigurator: ThirdPartyConfigurator
    
    public init(application: UIApplication, window: UIWindow, launchOptions: [AnyHashable: Any]) {
        self.app = application
        self.window = window
        root = RootConfigurator(window: window)
        thirdPartyConfigurator = ThirdPartyConfigurator(application: application, launchOptions: launchOptions)
    }
    
    public func start() {
        thirdPartyConfigurator.setup()
        root.router.openLoginScreen()
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [AnyHashable: Any]) -> Bool {
        return thirdPartyConfigurator.application(app, open: url, options: options)
    }
}
