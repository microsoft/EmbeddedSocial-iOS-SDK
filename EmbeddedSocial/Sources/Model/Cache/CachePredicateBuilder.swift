//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CachePredicateBuilderType {
    func predicate(with type: Cacheable.Type) -> NSPredicate
    
    func predicate(with type: Cacheable.Type, handle: String) -> NSPredicate
}

struct CachePredicateBuilder: CachePredicateBuilderType {
    
    func predicate(with type: Cacheable.Type) -> NSPredicate {
        return NSPredicate(format: "typeid = %@", type.typeIdentifier)
    }
    
    func predicate(with type: Cacheable.Type, handle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", type.typeIdentifier, handle)
    }
}
