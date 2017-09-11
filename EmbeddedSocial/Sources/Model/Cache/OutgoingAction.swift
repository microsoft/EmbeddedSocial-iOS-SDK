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
    
    enum ActionType: String {
        case follow
        case unfollow
        case block
        case unblock
    }
    
    let type: ActionType
    let method: HTTPMethod
    fileprivate(set) var entityHandle: String
    
    var combinedHandle: String {
        return "\(type)-\(method)-\(entityHandle)"
    }
    
    required init(type: ActionType, method: HTTPMethod, entityHandle: String) {        
        self.type = type
        self.method = method
        self.entityHandle = entityHandle
    }
    
    init?(json: [String: Any]) {
        guard let entityHandle = json["entityHandle"] as? String,
            let rawMethod = json["method"] as? String,
            let method = HTTPMethod(rawValue: rawMethod),
            let rawType = json["type"] as? String,
            let type = ActionType(rawValue: rawType)
            else {
                return nil
        }
        self.type = type
        self.entityHandle = entityHandle
        self.method = method
    }
}

extension OutgoingAction: Cacheable {
    
    func setHandle(_ handle: String?) {
        // nothing
    }
    
    func getHandle() -> String? {
        return combinedHandle
    }
    
    func encodeToJSON() -> Any {
        return [
            "entityHandle": entityHandle,
            "method": method.rawValue,
            "type": type.rawValue
        ]
    }
}

extension OutgoingAction: Hashable {

    public static func ==(lhs: OutgoingAction, rhs: OutgoingAction) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return type.hashValue ^ entityHandle.hashValue ^ method.hashValue
    }
}

extension OutgoingAction: CustomStringConvertible {
    
    var description: String {
        return combinedHandle
    }
}
