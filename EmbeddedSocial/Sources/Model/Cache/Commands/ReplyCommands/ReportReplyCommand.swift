//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportReplyCommand: ReplyCommand {
    
    var reportReason: ReportReason
    
    required init?(json: [String: Any]) {
        guard let reportReason = json["reportReason"] as? String else {
            return nil
        }
        
        self.reportReason = ReportReason(rawValue: reportReason)!
        
        super.init(json: json)
    }
    
    init(reply: Reply, reportReason: ReportReason) {
        self.reportReason = reportReason
        super.init(reply: reply)
    }
    
    override func encodeToJSON() -> Any {
        return [
            "reply": reply.encodeToJSON(),
            "type": typeIdentifier,
            "reportReason": reportReason.rawValue
        ]
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        reply.commentHandle = relatedHandle
    }
    
    override func getRelatedHandle() -> String? {
        return reply.commentHandle
    }
}
