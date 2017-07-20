//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Response from get builds current */
open class BuildsCurrentResponse: JSONEncodable {
    /** Gets or sets the date and time of the current build */
    public var dateAndTime: String?
    /** Gets or sets the Git commit hash that represents the current checkout */
    public var commitHash: String?
    /** Gets or sets the hostname that this code was built on */
    public var hostname: String?
    /** Gets or sets service api version number */
    public var serviceApiVersion: String?
    /** Gets or sets the list of files that were not committed at build time */
    public var dirtyFiles: [String]?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["dateAndTime"] = self.dateAndTime
        nillableDictionary["commitHash"] = self.commitHash
        nillableDictionary["hostname"] = self.hostname
        nillableDictionary["serviceApiVersion"] = self.serviceApiVersion
        nillableDictionary["dirtyFiles"] = self.dirtyFiles?.encodeToJSON()
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
