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
            let themeConfig = loadThemeConfig(for: themeName) else {
                return nil
        }
        
        let accentColorHexString = self.config["accentColor"] as? String
        let accentColor = UIColor(hexString: accentColorHexString ?? "")
        let palette = ThemePalette(config: themeConfig, accentColor: accentColor)
        
        return Theme(palette: palette, assets: themeAssets(for: themeName))
    }
    
    private func loadThemeConfig(for themeName: String) -> [String: Any]? {
        let bundle = Bundle(for: AppConfiguration.self)
        guard let path = bundle.path(forResource: themeName, ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path) as? [String: Any]
    }
    
    private func themeAssets(for themeName: String) -> ThemeAssets {
        return themeName == "dark" ? .dark : .light
    }
}
