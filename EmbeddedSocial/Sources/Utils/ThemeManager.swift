//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ThemeManager {
    static let shared = ThemeManager()
    
    var currentTheme: Theme? {
        didSet {
            NotificationCenter.default.post(name: .themeDidChange, object: self)
        }
    }
    
    private init() { }
}
