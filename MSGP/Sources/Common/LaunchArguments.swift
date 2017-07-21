//
//  LaunchArguments.swift
//  MSGP
//
//  Created by Vadim Bulavin on 7/21/17.
//  Copyright © 2017 Akvelon. All rights reserved.
//

import Foundation

public struct LaunchArguments {
    let app: UIApplication
    let window: UIWindow
    let launchOptions: [AnyHashable: Any]
    let menuHandler: SideMenuItemsProvider?
    let menuConfiguration: SideMenuType
    
    public init(app: UIApplication,
                window: UIWindow,
                launchOptions: [AnyHashable: Any],
                menuHandler: SideMenuItemsProvider?,
                menuConfiguration: SideMenuType) {
        self.app = app
        self.window = window
        self.launchOptions = launchOptions
        self.menuHandler = menuHandler
        self.menuConfiguration = menuConfiguration
    }
}
