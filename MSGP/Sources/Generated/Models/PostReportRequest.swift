//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to post (create) a report for content */
open class PostReportRequest: JSONEncodable {
    public enum Reason: String { 
        case threatsCyberbullyingHarassment = "ThreatsCyberbullyingHarassment"
        case childEndangermentExploitation = "ChildEndangermentExploitation"
        case offensiveContent = "OffensiveContent"
        case virusSpywareMalware = "VirusSpywareMalware"
        case contentInfringement = "ContentInfringement"
        case other = "Other"
        case _none = "None"
    }
    /** Gets or sets report reason */
    public var reason: Reason?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["reason"] = self.reason?.rawValue
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
