//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CachePredicateBuilder {
    func predicate(handle: String) -> NSPredicate
    
    func predicate(typeID: String, handle: String) -> NSPredicate
}

struct PredicateBuilder: CachePredicateBuilder {
    
    func predicate(handle: String) -> NSPredicate {
        return NSPredicate(format: "handle = %@", handle)
    }
    
    func predicate(typeID: String, handle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", typeID, handle)
    }
    
    func predicate(typeID: String, handle: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@ AND relatedHandle = %@", typeID, handle, relatedHandle)
    }
    
    func predicate(typeID: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND relatedHandle = %@", typeID, relatedHandle)
    }
}
