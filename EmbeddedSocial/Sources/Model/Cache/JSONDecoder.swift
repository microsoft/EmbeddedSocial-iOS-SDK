//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol JSONDecoder {
    static func decode<T>(type: T.Type, payload: Any?) -> T?
}

extension Decoders: JSONDecoder {
    static func decode<T>(type: T.Type, payload: Any?) -> T? {
        return decodeOptional(clazz: type, source: payload as AnyObject).value as? T
    }
}