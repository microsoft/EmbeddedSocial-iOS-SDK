//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class AppConfiguration {
    static let shared = AppConfiguration()
    
    let theme: Theme
    let settings: Settings
    
    private init() {
        guard let config = PlistLoader.loadPlist(name: Constants.configurationFilename),
            let theme = AppConfiguration.makeTheme(config: config),
            let settings = AppConfiguration.makeSettings(config: config) else {
                fatalError("Config file is wrong or missing.")
        }
        self.theme = theme
        self.settings = settings
    }
    
    private static func makeTheme(config appConfig: [String: Any]) -> Theme? {
        guard let config = appConfig["theme"] as? [String: Any] else {
            return nil
        }
        return Theme(config: config)
    }
    
    private static func makeSettings(config appConfig: [String: Any]) -> Settings? {
        guard let config = appConfig["application"] as? [String: Any] else {
            return nil
        }
        return Settings(config: config)
    }
}
