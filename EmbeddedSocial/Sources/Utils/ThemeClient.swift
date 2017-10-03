//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol ThemeClient: class {
    
}

extension ThemeClient {
    
    var theme: Theme? {
        get {
            return associated(to: self, key: &ThemeClientAssociationKeys.theme) { nil }
        }
        set {
            associate(to: self, key: &ThemeClientAssociationKeys.theme, value: newValue)
        }
    }
}

extension NSObject: ThemeClient {}

struct ThemeClientAssociationKeys {
    static fileprivate var theme: UInt8 = 0
}




