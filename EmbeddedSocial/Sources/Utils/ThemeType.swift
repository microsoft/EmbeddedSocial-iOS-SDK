//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum ThemeType: String {
    case light
    case dark
    
    var configName: String {
        switch self {
        case .light:
            return "light_theme"
        case .dark:
            return "dark_theme"
        }
    }
}
