//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Request to put push registration (register or update) */
open class PutPushRegistrationRequest: JSONEncodable {
    /** Gets or sets last updated time from the OS in ISO 8601 format.              This is used to expire out registrations that have not been updated every 30 days. */
    public var lastUpdatedTime: String?
    /** Gets or sets language of the user */
    public var language: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["lastUpdatedTime"] = self.lastUpdatedTime
        nillableDictionary["language"] = self.language
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
