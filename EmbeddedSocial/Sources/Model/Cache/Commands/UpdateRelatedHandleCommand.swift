//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class UpdateRelatedHandleCommand: OutgoingCommand {
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
        let json: [String: Any?] = [
            "type": typeIdentifier,
            "handle": handle
        ]
        return json.flatMap { $0 }
    }
    
    override func getHandle() -> String? {
        return handle
    }
}
