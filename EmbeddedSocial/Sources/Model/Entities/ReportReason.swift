//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation

enum ReportReason: String {
    case threatsCyberbullyingHarassment = "ThreatsCyberbullyingHarassment"
    case childEndangermentExploitation = "ChildEndangermentExploitation"
    case offensiveContent = "OffensiveContent"
    case virusSpywareMalware = "VirusSpywareMalware"
    case contentInfringement = "ContentInfringement"
    case other = "Other"
    case _none = "None"
    
    static var orderedReasons: [ReportReason] = [
        .virusSpywareMalware,
        .threatsCyberbullyingHarassment,
        .childEndangermentExploitation,
        .offensiveContent,
        .contentInfringement,
        .other
    ]
    
    static var readableReasons: [ReportReason: String] = [
        .threatsCyberbullyingHarassment: "Threats, Cyberbullying, Harassment",
        .childEndangermentExploitation: "Child Endangerment or Exploitation",
        .offensiveContent: "Offensive Content",
        .virusSpywareMalware: "Unsolicited/spam",
        .contentInfringement: "Content Infringement",
        .other: "Other"
    ]
}

extension ReportReason {
    init(reason: PostReportRequest.Reason) {
        if let mappedReason = ReportReason(rawValue: reason.rawValue) {
            self = mappedReason
        } else {
            self = .other
        }
    }
}
