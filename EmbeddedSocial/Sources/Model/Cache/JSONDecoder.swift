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
        addUserCommandDecoder()
    }
    
    private static func addUserCommandDecoder() {
        Decoders.addDecoder(clazz: UserCommand.self) { source, instance in
            guard let payload = source as? [String: Any],
                let item = UserCommand.command(from: payload) else {
                    return .failure(.typeMismatch(expected: "UserCommand", actual: "\(source)"))
            }
            return .success(item)
        }
    }
}
