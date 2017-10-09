//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol Themeable: class {
    func apply(theme: Theme?)
}

extension Themeable {
    
    var theme: Theme? {
        get {
            return associated(to: self, key: &ThemeableAssociationKeys.theme) { nil }
        }
        set {
            associate(to: self, key: &ThemeableAssociationKeys.theme, value: newValue)
        }
    }
}

struct ThemeableAssociationKeys {
    static fileprivate var theme: UInt8 = 0
}




