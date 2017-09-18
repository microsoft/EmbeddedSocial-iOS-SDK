//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UserCommand: OutgoingCommand {
    let user: User
    
    override var combinedHandle: String {
        return "\(super.combinedHandle)-\(user.uid)"
    }
    
    required init?(json: [String: Any]) {
        guard let userJSON = json["user"] as? [String: Any],
            let user = User(memento: userJSON) else {
                return nil
        }
        
        self.user = user
        
        super.init(json: json)
    }
    
    required init(user: User) {
        self.user = user
        super.init(json: [:])!
    }
    
    func apply(to user: inout User) {
        
    }
    
    override func encodeToJSON() -> Any {
        return [
            "user": user.encodeToJSON(),
            "type": typeIdentifier
        ]
    }
}
