//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

protocol JSONDecoderProtocol {
    static func setupDecoders()
    
    static func decode<T>(type: T.Type, payload: Any?) -> T?
}

extension Decoders: JSONDecoderProtocol {
    static func decode<T>(type: T.Type, payload: Any?) -> T? {
        return decodeOptional(clazz: type, source: payload as AnyObject).value as? T
    }
}

extension JSONDecoderProtocol {
    
    static func setupDecoders() {
        addOutgoingCommandDecoder()
    }
    
    private static func addOutgoingCommandDecoder() {
        Decoders.addDecoder(clazz: OutgoingCommand.self) { source, instance in
            guard let payload = source as? [String: Any],
                let item = OutgoingCommand.command(from: payload) else {
                    return .failure(.typeMismatch(expected: "OutgoingCommand", actual: "\(source)"))
            }
            return .success(item)
        }
    }
}
