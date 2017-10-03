//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

final class ReportCommentCommand: CommentCommand {
    
    var reportReason: ReportReason
    
    required init?(json: [String: Any]) {
        guard let reportReason = json["reportReason"] as? String else {
            return nil
        }
        
        self.reportReason = ReportReason(rawValue: reportReason)!
        
        super.init(json: json)
    }
    
    init(comment: Comment, reportReason: ReportReason) {
        self.reportReason = reportReason
        super.init(comment: comment)
    }
    
    override func encodeToJSON() -> Any {
        return [
            "comment": comment.encodeToJSON(),
            "type": typeIdentifier,
            "reportReason": reportReason.rawValue
        ]
    }
    
    override func setRelatedHandle(_ relatedHandle: String?) {
        comment.topicHandle = relatedHandle
    }
    
    override func getRelatedHandle() -> String? {
        return comment.topicHandle
    }
}
