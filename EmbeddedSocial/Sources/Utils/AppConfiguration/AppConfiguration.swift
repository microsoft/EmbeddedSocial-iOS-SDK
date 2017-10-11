//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AppConfigurationType {
    var theme: Theme { get }
    var settings: Settings { get }
}

class AppConfiguration: AppConfigurationType {
    let theme: Theme
    let settings: Settings

    init(theme: Theme, settings: Settings) {
        self.theme = theme
        self.settings = settings
    }
}
