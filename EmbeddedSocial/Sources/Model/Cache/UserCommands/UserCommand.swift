//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserCommand {
    let user: User
    
    var combinedHandle: String {
        return "\(String(describing: type(of: self)))-\(user.uid)"
    }
    
    var inverseCommand: UserCommand? {
        return nil
    }
    
    required init(user: User) {
        self.user = user
    }
    
    init?(json: [String: Any]) {
        guard let userJSON = json["user"] as? [String: Any],
            let user = User(memento: userJSON) else {
            return nil
        }
        self.user = user
    }
    
    static func command(from json: [String: Any]) -> UserCommand? {
        guard let userJSON = json["user"] as? [String: Any],
            let user = User(memento: userJSON),
            let typeName = json["type"] as? String else {
                return nil
        }
        
        var typeNames: [String: UserCommand.Type] = [:]
        
        for type in allCommandTypes {
            typeNames[type.typeIdentifier] = type
        }
        
        guard let matchingType = typeNames[typeName] else {
            return nil
        }
        
        return matchingType.init(user: user)
    }
    
    static var allCommandTypes: [UserCommand.Type] = [
        FollowCommand.self,
        UnfollowCommand.self,
        CancelPendingCommand.self,
        BlockCommand.self,
        UnblockCommand.self
    ]
    
    func encodeToJSON() -> Any {
        return [
            "user": user.encodeToJSON(),
            "type": String(describing: type(of: self))
        ]
    }
    
    func apply(to user: inout User) {
        // nothing
    }
}

extension UserCommand: Cacheable {
    func setHandle(_ handle: String?) {
        // nothing
    }
    
    func getHandle() -> String? {
        return combinedHandle
    }
}
