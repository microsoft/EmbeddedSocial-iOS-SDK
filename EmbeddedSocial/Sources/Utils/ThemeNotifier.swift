//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ThemeNotifier {
    private var observer: NSObjectProtocol!
    
    weak var host: ThemeClient?
    var mapping = [String: (ThemeClient, Theme) -> Void]()
    
    init(host: ThemeClient) {
        self.host = host
    }
    
    func observe() {
        observer = NotificationCenter.default.addObserver(
            forName: .themeDidChange,
            object: ThemeManager.shared,
            queue: .main,
            using: { [weak self] _ in
                self?.handle()
        })
    }
    
    func handle() {
        guard let host = host,
            let theme = ThemeManager.shared.currentTheme,
            let action = mapping[String(describing: type(of: theme))] else {
                return
        }
        
        action(host, theme)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer)
    }
}
