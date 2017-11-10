//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

class ReportUserCommand: UserCommand {
    
    let reason: ReportReason
    
    init(user: User, reason: ReportReason) {
        self.reason = reason
        super.init(user: user)
    }
    
    required init?(json: [String : Any]) {
        guard let rawReason = json["reason"] as? String,
            let reason = ReportReason(rawValue: rawReason) else {
                return nil
        }
        self.reason = reason
        super.init(json: json)
    }
    
    override func encodeToJSON() -> Any {
        return [
            "user": user.encodeToJSON(),
            "type": typeIdentifier,
            "reason": reason.rawValue
        ]
    }
}
