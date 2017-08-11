//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol Cacheable {
    func encodeToJSON() -> Any
    
    var handle: String { get set }
}

struct CacheableAssociatedKey {
    static var handle: UInt8 = 0
}

extension Cacheable {
    var handle: String {
        get {
            return associated(to: self, key: &CacheableAssociatedKey.handle) { UUID().uuidString }
        }
        set {
            associate(to: self, key: &CacheableAssociatedKey.handle, value: newValue)
        }
    }
}
