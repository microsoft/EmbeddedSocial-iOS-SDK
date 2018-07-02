//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UpdateRelatedHandleCommand: OutgoingCommand {
    let oldHandle: String
    let newHandle: String
    
    required init?(json: [String: Any]) {
        guard let oldHandle = json["oldHandle"] as? String,
        let newHandle = json["newHandle"] as? String else {
            return nil
        }
        self.oldHandle = oldHandle
        self.newHandle = newHandle
        super.init(json: json)
    }
    
    required init(oldHandle: String, newHandle: String) {
        self.oldHandle = oldHandle
        self.newHandle = newHandle
        super.init(json: [:])!
    }
    
    override func encodeToJSON() -> Any {
        let json: [String: Any?] = [
            "type": typeIdentifier,
            "oldHandle": oldHandle,
            "newHandle": newHandle
        ]
        return json.flatMap { $0 }
    }
    
    override func getHandle() -> String? {
        return oldHandle + "-" + newHandle
    }
}
