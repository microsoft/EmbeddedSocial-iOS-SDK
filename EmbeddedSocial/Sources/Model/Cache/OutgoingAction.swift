//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingAction {
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete  = "DELETE"
    }
    
    let url: String
    let method: HTTPMethod
    fileprivate(set) var handle: String
    
    init(url: String, method: HTTPMethod, handle: String) {
        _ = OutgoingAction.__once_initDecoder
        
        self.url = url
        self.method = method
        self.handle = handle
    }
    
    init?(json: [String: Any]) {
        _ = OutgoingAction.__once_initDecoder
        
        guard let handle = json["handle"] as? String,
            let rawMethod = json["method"] as? String,
            let method = HTTPMethod(rawValue: rawMethod),
            let url = json["url"] as? String else {
                return nil
        }
        self.url = url
        self.handle = handle
        self.method = method
    }
    
    static let __once_initDecoder: () = {
        Decoders.addDecoder(clazz: OutgoingAction.self) { source, instance in
            guard let payload = source as? [String: Any],
                let item = OutgoingAction(json: payload)
                else {
                    return .failure(.typeMismatch(expected: "OutgoingAction", actual: "\(source)"))
            }
            return .success(item)
        }
    }()
}

extension OutgoingAction: Cacheable {
    
    func setHandle(_ handle: String?) {
        guard let handle = handle else { return }
        self.handle = handle
    }
    
    func getHandle() -> String? {
        return handle
    }
    
    func encodeToJSON() -> Any {
        let encoded: [String: Any?] = [
            "handle": handle,
            "method": method.rawValue,
            "url": url
        ]
        return encoded.flatMap { $0 }
    }
}

extension OutgoingAction: Hashable {

    public static func ==(lhs: OutgoingAction, rhs: OutgoingAction) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return url.hashValue ^ handle.hashValue ^ method.hashValue
    }
}

extension OutgoingAction: CustomStringConvertible {
    
    var description: String {
        return "\(url) \(method) \(handle)"
    }
}
