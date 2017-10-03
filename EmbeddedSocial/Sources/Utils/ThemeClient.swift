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
        
        theme_handler.mapping[String(describing: type.self)] = { (themeUser: ThemeClient, theme: Theme) in
            guard let themeUser = themeUser as? Self,
                let theme = theme as? T else {
                    return
            }
            
            apply(themeUser, theme)
        }
    }
    
    fileprivate var theme_handler: ThemeNotitifer {
        if let handler = objc_getAssociatedObject(self, &key) as? ThemeNotitifer {
            return handler
        } else {
            let handler = ThemeNotitifer(host: self)
            handler.observe()
            objc_setAssociatedObject(self, &key, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return handler
        }
    }
}

extension NSObject: ThemeClient {}

private var key = "themeNotifier"
