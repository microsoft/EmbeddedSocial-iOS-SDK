//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UpdateNotificationsStatusCommand: OutgoingCommand {
    let handle: String
    
    required init?(json: [String: Any]) {
        guard let handle = json["handle"] as? String else {
            return nil
        }
        
        self.handle = handle
        
        super.init(json: json)
    }
    
    required init(handle: String) {
        self.handle = handle
        super.init(json: [:])!
    }
    
    override func encodeToJSON() -> Any {
        return [
            "handle": handle,
            "type": typeIdentifier
        ]
    }
    
    override func getHandle() -> String? {
        return handle
    }
}
