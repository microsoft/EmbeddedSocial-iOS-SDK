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
}

//extension ReportReason {
//    init(reason: PostReportRequest.Reason) {
//        self = ReportReason(rawValue: reason.rawValue)
//        switch reason {
//        case .threatsCyberbullyingHarassment: self = .threatsCyberbullyingHarassment
//        case .childEndangermentExploitation: self = .childEndangermentExploitation
//        case offensiveContent = "OffensiveContent"
//        case virusSpywareMalware = "VirusSpywareMalware"
//        case contentInfringement = "ContentInfringement"
//        case other = "Other"
//        case _none = "None"
//        }
//    }
//}
