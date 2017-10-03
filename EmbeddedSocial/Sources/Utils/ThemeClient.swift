//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ThemeClient: class {
    
}

extension ThemeClient {
    
    func use<T: Theme>(_ type: T.Type, apply: @escaping (Self, T) -> Void) {
        if let theme = ThemeManager.shared.currentTheme as? T {
            apply(self, theme)
        }
        
        notifier.mapping[String(describing: type.self)] = { (themeUser: ThemeClient, theme: Theme) in
            guard let themeUser = themeUser as? Self,
                let theme = theme as? T else {
                    return
            }
            
            apply(themeUser, theme)
        }
    }
    
    fileprivate var notifier: ThemeNotifier {
        get {
            return associated(to: self, key: &ThemeClientAssociationKeys.notifier) { ThemeNotifier(host: self) }
        }
        set {
            associate(to: self, key: &ThemeClientAssociationKeys.notifier, value: newValue)
        }
    }
}

extension NSObject: ThemeClient {}

struct ThemeClientAssociationKeys {
    static fileprivate var notifier: UInt8 = 0
}




