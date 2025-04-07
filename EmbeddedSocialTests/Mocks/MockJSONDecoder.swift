//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

@testable import EmbeddedSocial

class MockJSONDecoder: JSONDecoderProtocol {
    
    //MARK: - setupDecoders

    static var setupDecodersCalled = false

    static func setupDecoders() {
        setupDecodersCalled = true
    }
    
    //MARK: - decode<T>

    static var decodeTypePayloadReceivedArguments: (type: AnyObject.Type, payload: Any?)?
    static var decodeTypePayloadCalled = true
    static var decodeTypePayloadReturnValue: AnyObject.Type?

    static func decode<T>(type: T.Type, payload: Any?) -> T? {
        decodeTypePayloadReceivedArguments = (type: type as! AnyObject.Type, payload: payload)
        decodeTypePayloadCalled = true
        return decodeTypePayloadReturnValue as? T
    }
    
}
