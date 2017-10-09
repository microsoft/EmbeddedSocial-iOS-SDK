//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol AppConfigurationType {
    var theme: Theme { get }
}

class AppConfiguration: AppConfigurationType {
    let theme: Theme

    init(theme: Theme) {
        self.theme = theme
    }
}
