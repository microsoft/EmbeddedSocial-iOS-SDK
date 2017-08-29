//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol HandleMixin: class {
    var handle: String { get set }
}

struct HandleMixinAssociationKeys {
    static fileprivate var handle: UInt8 = 0
}

extension HandleMixin {
    
    var handle: String {
        get {
            return associated(to: self, key: &HandleMixinAssociationKeys.handle) { UUID().uuidString }
        }
        set {
            associate(to: self, key: &HandleMixinAssociationKeys.handle, value: newValue)
        }
    }
}
