//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

struct CacheableItem: Cacheable, Equatable {
    let handle: String
    let name: String

    func encodeToJSON() -> Any {
        return ["handle": handle, "name": name]
    }
    
    func getHandle() -> String? {
        return handle
    }
    
    static func ==(lhs: CacheableItem, rhs: CacheableItem) -> Bool {
        return lhs.handle == rhs.handle && lhs.name == rhs.name
    }
}
