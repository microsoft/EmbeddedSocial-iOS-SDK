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
    
    var oppositeCommand: UserCommand? {
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
    
    func encodeToJSON() -> Any {
        return [
            "user": user.encodeToJSON(),
        ]
    }
}

extension UserCommand: Cacheable {
    func setHandle(_ handle: String?) {
        // nothing
    }
    
    func getHandle() -> String? {
        return user.uid
    }
}
