//
//  MSGP.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/10/17.
//  Copyright © 2017 Igor Popov. All rights reserved.
//

import Foundation

public final class MSGP {
    private let application: UIApplication
    private let window: UIWindow
    private let root: RootConfigurator
    
    public init(application: UIApplication, window: UIWindow, launchOptions: [AnyHashable: Any]) {
        self.application = application
        self.window = window
        root = RootConfigurator(window: window)
        ThirdPartyConfigurator.setup(application: application, launchOptions: launchOptions)
    }
    
    public func start() {
        root.router.openLoginScreen()
    }
}
