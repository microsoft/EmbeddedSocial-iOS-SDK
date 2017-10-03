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
        guard let themeName = self.config["theme"] as? String,
            let theme = Theme(filename: themeName) else {
                fatalError("Theme is wrong or missing. Please check the config file.")
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
}
