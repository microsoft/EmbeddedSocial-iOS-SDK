//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AppConfigurationType {
    var theme: Theme { get }
}

class AppConfiguration: AppConfigurationType {
    
    private let config: [String: Any]
    
    lazy var theme: Theme = { [unowned self] in
        guard let theme = self.makeTheme() else {
            fatalError("Theme config is wrong or missing.")
        }
        return theme
    }()
    
    init?(filename: String) {
        guard let path = Bundle(for: type(of: self)).path(forResource: filename, ofType: "plist"),
            let config = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                return nil
        }
        self.config = config
    }
    
    private func makeTheme() -> Theme? {
        guard let themeName = self.config["theme"] as? String,
            let accentColorHexString = self.config["accentColor"] as? String,
            let themeConfigPath = Bundle(for: type(of: self)).path(forResource: themeName, ofType: "plist"),
            let themeConfig = NSDictionary(contentsOfFile: themeConfigPath) as? [String: Any] else {
                return nil
        }
        
        let palette = ThemePalette(config: themeConfig, accentColor: UIColor(hexString: accentColorHexString))
        return Theme(palette: palette)
    }
}
