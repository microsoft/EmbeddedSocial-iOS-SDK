//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol JSONDecoder {
    static func setupDecoders()
    
    static func decode<T>(type: T.Type, payload: Any?) -> T?
}

extension Decoders: JSONDecoder {
    static func decode<T>(type: T.Type, payload: Any?) -> T? {
        return decodeOptional(clazz: type, source: payload as AnyObject).value as? T
    }
}

extension JSONDecoder {
    
    static func setupDecoders() {
        addOutgoingActionsDecoder()
    }
    
    private static func addOutgoingActionsDecoder() {
        Decoders.addDecoder(clazz: OutgoingAction.self) { source, instance in
            guard let payload = source as? [String: Any],
                let item = OutgoingAction(json: payload)
                else {
                    return .failure(.typeMismatch(expected: "OutgoingAction", actual: "\(source)"))
            }
            return .success(item)
        }
    }
}
