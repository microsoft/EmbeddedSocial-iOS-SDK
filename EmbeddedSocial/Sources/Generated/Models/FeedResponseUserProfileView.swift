//
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See LICENSE in the project root for license information.
//

import Foundation


/** Feed response */
open class FeedResponseUserProfileView: JSONEncodable {
    /** Gets or sets feed data */
    public var data: [UserProfileView]?
    /** Gets or sets feed cursor */
    public var cursor: String?

    public init() {}

    // MARK: JSONEncodable
    open func encodeToJSON() -> Any {
        var nillableDictionary = [String:Any?]()
        nillableDictionary["data"] = self.data?.encodeToJSON()
        nillableDictionary["cursor"] = self.cursor
        let dictionary: [String:Any] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
