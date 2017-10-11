//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension Authorization {
    static var anonymous: String {
        return "Anon AK=\(AppConfiguration.shared.settings.appKey)"
    }
}
