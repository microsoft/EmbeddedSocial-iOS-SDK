//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import UIKit

struct AppThemeConfigurationCommand: Command {
    
    private let theme: Theme?
    
    init(theme: Theme? = AppConfiguration.shared.theme) {
        self.theme = theme
    }
    
    func execute() {
        guard let palette = theme?.palette else {
            return
        }
        UINavigationBar.appearance().barTintColor = palette.navigationBarBackground
        UINavigationBar.appearance().tintColor = palette.navigationBarTint
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: palette.navigationBarTitle]
    }
}
