//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation
@testable import EmbeddedSocial

struct CacheableItemDecoder: JSONDecoder {
    static func decode<T>(type: T.Type, payload: Any?) -> T? {
        guard T.self is CacheableItem.Type,
            let payload = payload as? [String: Any],
            let name = payload["name"] as? String,
            let handle = payload["handle"] as? String else {
                return nil
        }
        return CacheableItem(handle: handle, name: name) as? T
    }
}
