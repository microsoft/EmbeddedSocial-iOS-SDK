//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

extension UserDefaults: KeyValueStorage {
    /// User Bundle.main.bundleIdentifier for key to remove whole bundle's storage
    func purge(key: String) {
        UserDefaults.standard.removePersistentDomain(forName: key)
    }
}
