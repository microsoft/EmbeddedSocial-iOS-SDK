//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

protocol Cacheable {
    func encodeToJSON() -> Any
    
    func getHandle() -> String?
}

struct CacheableAssociatedKey {
    static var handle: UInt8 = 0
}

extension Cacheable {

    func getHandle() -> String? {
        return nil
    }
    
    var typeIdentifier: String {
        return type(of: self).typeIdentifier
    }
    
    static var typeIdentifier: String {
        return String(describing: self)
    }
}
