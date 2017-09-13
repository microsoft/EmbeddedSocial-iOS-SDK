//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol CachePredicateBuilder {
    func predicate(handle: String) -> NSPredicate
    func predicate(typeID: String, handle: String) -> NSPredicate
    func predicate(typeID: String) -> NSPredicate
}

struct PredicateBuilder: CachePredicateBuilder {
    
    static func predicate(typeID: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@", typeID)
    }
    
    static func predicate(typeID: String, handle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@", typeID, handle)
    }
    
    static func predicate(action: OutgoingAction) -> NSPredicate {
        return predicate(typeID: action.typeIdentifier, handle: action.combinedHandle)
    }
    
    static func predicate(for command: UserCommand) -> NSPredicate {
        return predicate(typeID: UserCommand.typeIdentifier, handle: command.combinedHandle)
    }
    
    func predicate(handle: String) -> NSPredicate {
        return NSPredicate(format: "handle = %@", handle)
    }
    
    func predicate(typeID: String) -> NSPredicate {
        return PredicateBuilder.predicate(typeID: typeID)
    }
    
    func predicate(typeID: String, handle: String) -> NSPredicate {
        return PredicateBuilder.predicate(typeID: typeID, handle: handle)
    }
    
    func predicate(typeID: String, handle: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND handle = %@ AND relatedHandle = %@", typeID, handle, relatedHandle)
    }
    
    func predicate(typeID: String, relatedHandle: String) -> NSPredicate {
        return NSPredicate(format: "typeid = %@ AND relatedHandle = %@", typeID, relatedHandle)
    }
    
    func predicate(action: OutgoingAction) -> NSPredicate {
        return PredicateBuilder.predicate(action: action)
    }
}
