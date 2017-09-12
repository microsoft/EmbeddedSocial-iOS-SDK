//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class OutgoingAction {
    
    enum ActionType: String {
        case follow
        case unfollow
        case block
        case unblock
        case cancelPending
        
        static func inverseType(to actionType: ActionType) -> ActionType? {
            switch actionType {
            case .follow:
                return .unfollow
            case .unfollow:
                return .follow
            case .block:
                return .unblock
            case .unblock:
                return .block
            case .cancelPending:
                return .follow
            }
        }
    }
    
    var type: ActionType
    fileprivate(set) var entityHandle: String
    
    var combinedHandle: String {
        return "\(type)-\(entityHandle)"
    }
    
    required init(type: ActionType, entityHandle: String) {
        self.type = type
        self.entityHandle = entityHandle
    }
    
    init?(json: [String: Any]) {
        guard let entityHandle = json["entityHandle"] as? String,
            let rawType = json["type"] as? String,
            let type = ActionType(rawValue: rawType)
            else {
                return nil
        }
        self.type = type
        self.entityHandle = entityHandle
    }
    
    var inverseAction: OutgoingAction? {
        guard let type = ActionType.inverseType(to: self.type) else {
            return nil
        }
        return OutgoingAction(type: type, entityHandle: entityHandle)
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
            "type": type.rawValue
        ]
    }
}

extension OutgoingAction: Hashable {

    public static func ==(lhs: OutgoingAction, rhs: OutgoingAction) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return type.hashValue ^ entityHandle.hashValue
    }
}

extension OutgoingAction: CustomStringConvertible {
    
    var description: String {
        return combinedHandle
    }
}
