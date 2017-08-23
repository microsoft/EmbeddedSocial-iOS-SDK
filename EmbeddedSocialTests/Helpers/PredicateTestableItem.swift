//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

final class PredicateTestableItem: NSObject {
    dynamic let name: String
    dynamic let handle: String
    dynamic let relatedHandle: String
    dynamic let typeid = "PredicateTestableItem"
    
    init(name: String, handle: String, relatedHandle: String) {
        self.name = name
        self.handle = handle
        self.relatedHandle = relatedHandle
    }
}

extension PredicateTestableItem: Cacheable {
    func encodeToJSON() -> Any {
        return ["handle": handle, "name": name, "relatedHandle": relatedHandle]
    }
    
    func getHandle() -> String? {
        return handle
    }
    
    func getRelatedHandle() -> String? {
        return relatedHandle
    }
}

extension PredicateTestableItem {
    
    static func ==(lhs: PredicateTestableItem, rhs: PredicateTestableItem) -> Bool {
        return lhs.handle == rhs.handle && lhs.name == rhs.name && lhs.relatedHandle == rhs.relatedHandle
    }
}
