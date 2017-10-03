//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
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
