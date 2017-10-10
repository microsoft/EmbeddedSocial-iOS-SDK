//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class Theme {
    let palette: ThemePalette
    let assets: ThemeAssets
    
    init?(config: [String: Any]) {
        guard let name = config["name"] as? String,
            let paletteConfig = Theme.paletteConfig(for: name) else {
                return nil
        }
        
        let accentColorHexString = config["accentColor"] as? String
        let accentColor = UIColor(hexString: accentColorHexString ?? "")
        palette = ThemePalette(config: paletteConfig, accentColor: accentColor)
        assets = Theme.assets(for: name)
    }
    
    private static func paletteConfig(for name: String) -> [String: Any]? {
        let bundle = Bundle(for: Theme.self)
        guard let path = bundle.path(forResource: name, ofType: "plist") else {
            return nil
        }
        return NSDictionary(contentsOfFile: path) as? [String: Any]
    }
    
    private static func assets(for themeName: String) -> ThemeAssets {
        return themeName == "dark" ? .dark : .light
    }
}
